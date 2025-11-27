# SPDX-License-Identifier: MIT OR Apache-2.0

exp2m1_ref(x::BigFloat) = exp2(x) - big"1"
exp2m1_ref(x::Float64) = Float64(exp2m1_ref(BigFloat(x)))
exp2m1_ref(x::Float32) = Float32(exp2m1_ref(BigFloat(x)))


for T in (Float32, )
    @testset "cr_exp2m1($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_exp2m1(T(NaN)))
        @test isnan(PureLibm.cr_exp2m1(-T(NaN)))
        # exp2m1(±0) returns 0
        @test PureLibm.cr_exp2m1(T(0.0)) == T(0)
        @test PureLibm.cr_exp2m1(-T(0.0)) == T(0)
        # exp2m1(−∞) returns -1
        @test PureLibm.cr_exp2m1(-T(Inf)) == -T(1)
        # exp2m1(+∞) returns +∞
        @test PureLibm.cr_exp2m1(T(Inf)) == T(Inf)
    end

    @testset "cr_exp2m1(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0), T(25), 64)...,
            rand_float(T(25), T(128), 64)...,
            # log2(prevfloat(Inf32)) == 128
            1:128...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if @unlikely(ux >= 0xc1c80000)
                # x <= -25.0f0
                -25.0f0,
                rand_float(-25.0f0, -T(Inf), 8)...,
                # elseif @unlikely(ax >= 0x43000000)
                # x >= 128.0f0
                128.0f0,
                rand_float(128.0f0, T(Inf), 8)...,

                # ---- elseif @unlikely(ax < 0x3df95f1f)
                # |x| < 0.12176346f0
                rand_float(0.0f0, 0.12176346f0, 128)...,
                # - else: skip
                0.12176346f0,
                # |x| < 0.056553647f0
                rand_float(0.0f0, 0.12176346f0, 64)...,
                # - else
                0.056553647f0,
                rand_float(0.056553647f0, 0.12176346f0, 64)...,
                # |x| < 1.44e-2/log(2) == 0.020774808f0
                rand_float(0.0f0, 0.020774808f0, 64)...,
                # - else
                0.020774808f0,
                rand_float(0.020774808f0, 0.056553647f0, 64)...,
                # |x| < 3.64e-3/log(2) == 0.00525141f0
                rand_float(0.0f0, 0.00525141f0, 64)...,
                # - else
                0.00525141f0,
                rand_float(0.00525141f0, 0.020774808f0, 64)...,
                # |x| < 4.8e-4/log(2) == 0.00069249363f0
                rand_float(0.0f0, 0.00069249363f0, 64)...,
                # - else
                0.00069249363f0,
                rand_float(0.00069249363f0, 0.00525141f0, 64)...,
                # |x| < 1.745e-5/log(2) == 2.5175028f-5
                rand_float(0.0f0, 2.5175028f-5, 64)...,
                # - else
                2.5175028f-5,
                rand_float(2.5175028f-5, 0.00069249363f0, 64)...,
                # |x| < 2.58e-8/log(2) == 3.7221533f-8
                rand_float(0.0f0, 3.7221533f-8, 64)...,
                # - else
                3.7221533f-8,
                rand_float(3.7221533f-8, 2.5175028f-5, 64)...,
                
                # if @unlikely(ux == 0xb3d85005)
                # x = -1.0072839f-7
                -1.0072839f-7,
                # if @unlikely(ux == 0x3338428d)
                # x = 4.2901366f-8
                4.2901366f-8,
                # if @unlikely(ux == 0x388bca4f)
                # x = 6.6657194f-5
                6.6657194f-5,

                # ---- else
                # general range
                #   x > -25.0f0 and |x| < 128.0f0 and |x| >= 0.12176346f0
                #   x in (-25, -0.12176346f0] and [0.12176346f0, 128)
                rand_float(0.12176346f0, 128.0f0, 64)...,
                rand_float(-0.12176346f0, -25.0f0, 64)...,
            ])
        end
        @testset "cr_exp2m1($(repr(x)))" for x in test_x
            res = PureLibm.cr_exp2m1(x)
            # Test against system libm
            # @test res ≈ exp2m1_ref(x)
            # Test against MPFR
            @test res === T(exp2m1_ref(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=nextfloat(Float32(128)))
neg_range = (lo=Float32(-0.0), hi=-nextfloat(Float32(128)))
if "cr_exp2m1.fast" in CheckExhaustive
    @testset "cr_exp2m1-exhaustive.fast" begin
        test_float_range(exp2m1_ref, PureLibm.cr_exp2m1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(exp2m1_ref, PureLibm.cr_exp2m1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_exp2m1" in CheckExhaustive
    @testset "cr_exp2m1-exhaustive" begin
        test_float_range(exp2m1_ref, PureLibm.cr_exp2m1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(exp2m1_ref, PureLibm.cr_exp2m1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp2m1.fast,cr_exp2m1"
