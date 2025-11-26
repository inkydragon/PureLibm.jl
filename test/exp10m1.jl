# SPDX-License-Identifier: MIT OR Apache-2.0

exp10m1_ref(x::BigFloat) = exp10(x) - big"1"
exp10m1_ref(x::Float64) = Float64(exp10m1_ref(BigFloat(x)))
exp10m1_ref(x::Float32) = Float32(exp10m1_ref(BigFloat(x)))


for T in (Float32, )
    @testset "cr_exp10m1($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_exp10m1(T(NaN)))
        @test isnan(PureLibm.cr_exp10m1(-T(NaN)))
        # exp10m1(±0) returns ±0
        @test PureLibm.cr_exp10m1(T(0.0)) == T(0)
        @test PureLibm.cr_exp10m1(-T(0.0)) == -T(0)
        # exp10m1(−∞) returns -1
        @test PureLibm.cr_exp10m1(-T(Inf)) == -T(1)
        # exp10m1(+∞) returns +∞
        @test PureLibm.cr_exp10m1(T(Inf)) == T(Inf)
    end

    @testset "cr_exp10m1(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0), T(11), 64)...,
            rand_float(T(11), T(39), 64)...,
            # prevfloat(Inf32) == 3.4028235f38
            1:39...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if @unlikely(tu > 0xc0f0d2f1)
                # x < -7.5257497f0
                -7.5257497f0,
                rand_float(-7.5257497f0, -T(Inf), 4)...,
                # elseif @unlikely(ax > 0x421a209a)
                # x > 38.531837f0
                38.531837f0,
                rand_float(38.531837f0, T(Inf), 4)...,

                # ---- elseif @unlikely(ax < 0x3d89c604)
                # |x| < 0.1549/log(10) == 0.067272216f0
                rand_float(0.0f0, 0.067272216f0, 128)...,
                0.067272216f0,
                # - else located in later section
                # |x| < 8.44e-2/log(10) == 0.036654454f0
                rand_float(0.0f0, 0.036654454f0, 128)...,
                0.036654454f0,
                rand_float(0.036654454f0, 0.067272216f0, 128)...,
                # |x| < 1.44e-2/log(10) == 0.0062538404f0
                rand_float(0.0f0, 0.0062538404f0, 64)...,
                0.0062538404f0,
                rand_float(0.0062538404f0, 0.036654454f0, 64)...,
                # |x| < 3.64e-3/log(10) == 0.001580832f0
                rand_float(0.0f0, 0.001580832f0, 64)...,
                0.001580832f0,
                rand_float(0.001580832f0, 0.0062538404f0, 64)...,
                # |x| < 4.8e-4/log(10) == 0.00020846135f0
                rand_float(0.0f0, 0.00020846135f0, 32)...,
                0.00020846135f0,
                rand_float(0.00020846135f0, 0.001580832f0, 32)...,
                # |x| < 1.745e-5/log(10) == 7.5784387f-6
                rand_float(0.0f0, 7.5784387f-6, 32)...,
                7.5784387f-6,
                rand_float(7.5784387f-6, 0.00020846135f0, 32)...,
                # |x| < 2.58e-8/log(10) == 1.1204798f-8
                rand_float(0.0f0, 1.1204798f-8, 16)...,
                1.1204798f-8,
                # - else
                #   if @unlikely(tu == 0xb6fa215b)
                -7.4544637f-6,
                rand_float(1.1204798f-8, 7.5784387f-6, 16)...,
                # |x| <= 4.8216374f-17
                rand_float(0.0f0, 4.8216374f-17, 16)...,
                4.8216374f-17,
                # - else
                rand_float(4.8216374f-17, 1.1204798f-8, 16)...,
                #   if @unlikely(tu == 0x2c994b7b)
                #   x = 4.3569016f-12
                4.3569016f-12,

                # ---- else
                # -7.52575 < x < -0.1549/log(10) or 0.1549/log(10) < x < 38.5318
                -0.1549/log(10), 0.1549/log(10),
                rand_float(-T(0.1549/log(10)), -7.5257497f0, 8)...,
                rand_float(T(0.1549/log(10)), 38.531837f0, 8)...,
            ])
        end
        @testset "cr_exp10m1($(repr(x)))" for x in test_x
            res = PureLibm.cr_exp10m1(x)
            # Test against system libm
            # @test res ≈ exp10m1_ref(x)
            # Test against MPFR
            @test res === T(exp10m1_ref(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(39))
neg_range = (lo=Float32(-0.0), hi=Float32(-39))
if "cr_exp10m1.fast" in CheckExhaustive
    @testset "cr_exp10m1-exhaustive.fast" begin
        test_float_range(exp10m1_ref, PureLibm.cr_exp10m1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(exp10m1_ref, PureLibm.cr_exp10m1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_exp10m1" in CheckExhaustive
    @testset "cr_exp10m1-exhaustive" begin
        test_float_range(exp10m1_ref, PureLibm.cr_exp10m1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(exp10m1_ref, PureLibm.cr_exp10m1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp10m1.fast,cr_exp10m1"
