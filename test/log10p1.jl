# SPDX-License-Identifier: MIT OR Apache-2.0

log10p1_ref(x::BigFloat) = log10(1 + x)
log10p1_ref(x::Float64) = Float64(log10p1_ref(BigFloat(x)))
log10p1_ref(x::Float32) = Float32(log10p1_ref(BigFloat(x)))


for T in (Float32, )
    @testset "cr_log10p1($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_log10p1(T(NaN)))
        @test isnan(PureLibm.cr_log10p1(-T(NaN)))
        # log10p1(±0) returns ±0
        @test PureLibm.cr_log10p1(T(0)) == T(0)
        @test PureLibm.cr_log10p1(-T(0)) == -T(0)
        # log10p1(−1) returns −∞ and raises the "divide-by-zero" floating-point exception
        @test PureLibm.cr_log10p1(-T(1)) == -T(Inf)
        # log10p1(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < −1
        @test isnan(PureLibm.cr_log10p1(-T(1.1)))
        @test isnan(PureLibm.cr_log10p1(-T(2.0)))
        @test isnan(PureLibm.cr_log10p1(-T(100)))
        # log10p1(+∞) returns +∞
        @test PureLibm.cr_log10p1(T(Inf)) == T(Inf)
    end

    @testset "cr_log10p1(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0), T(1), 16)...,
            1:128...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if @unlikely(x == CR_LOG10P1F_ST[idx])
                0.0f0, 9.0f0, 99.0f0, 999.0f0,
                9999.0f0, 99999.0f0, 999999.0f0, 9.999999f6,

                # ---- if @unlikely(ub != lb)

                # if ax < 0x3d32743e
                # |x| < 0.04356789f0 (0x1.64e87cp-5f)
                0.04356789f0,
                rand_float(0.0f0, 0.04356789f0, 16)...,
                # if @unlikely(ux == 0xa6aba8af)
                # x = -1.191123f-15
                -1.191123f-15,
                # if @unlikely(ux == 0xaf39b9a7)
                # x = -1.6891609f-10
                -1.6891609f-10,
                # if @unlikely(ux == 0x399a7c00)
                # x = 0.00029465556f0
                0.00029465556f0,

                # - else
                # |x| >= 0.04356789f0
                rand_float(0.04356789f0, T(Inf), 128)...,
                #  if @unlikely(ux == 0x7956ba5e)
                # x = 6.968322f34
                6.968322f34,
                # if @unlikely(ux == 0xbd86ffb9)
                # x = -0.06591744f0
                -0.06591744f0,
            ])
        end
        @testset "cr_log10p1($(repr(x)))" for x in test_x
            res = PureLibm.cr_log10p1(x)
            # Test against system libm
            # @test res ≈ log10p1_ref(x)
            # Test against MPFR
            @test res === T(log10p1_ref(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(Inf))
neg_range = (lo=Float32(-0.0), hi=-nextfloat(Float32(1.0)))
if "cr_log10p1.fast" in CheckExhaustive
    @testset "cr_log10p1-exhaustive.fast" begin
        test_float_range(log10p1_ref, PureLibm.cr_log10p1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(log10p1_ref, PureLibm.cr_log10p1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_log10p1" in CheckExhaustive
    @testset "cr_log10p1-exhaustive" begin
        test_float_range(log10p1_ref, PureLibm.cr_log10p1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(log10p1_ref, PureLibm.cr_log10p1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log10p1.fast,cr_log10p1"
