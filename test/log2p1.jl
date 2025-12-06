# SPDX-License-Identifier: MIT OR Apache-2.0

log2p1_ref(x::BigFloat) = log2(1 + x)
log2p1_ref(x::Float64) = Float64(log2p1_ref(BigFloat(x)))
log2p1_ref(x::Float32) = Float32(log2p1_ref(BigFloat(x)))


for T in (Float32, )
    @testset "cr_log2p1($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
        # log2p1 Domain
        @testset "log2p1(x) >= 0, for x >= 0" begin
            f_domain = filter(x -> x >= 0, float_gen)
            @check log_domain(f = f_domain) = 0 <= PureLibm.cr_log2p1(f)
        end
        @testset "log2p1(x) <= 0, for -1 < x <= 0" begin
            f_domain = filter(x -> -1 < x <= 0, float_gen)
            @check log_domain(f = f_domain) = PureLibm.cr_log2p1(f) <= 0
        end

        # IEC 60559
        @test isnan(PureLibm.cr_log2p1(T(NaN)))
        @test isnan(PureLibm.cr_log2p1(-T(NaN)))
        # log2p1(±0) returns ±0
        @test PureLibm.cr_log2p1(T(0)) == T(0)
        @test PureLibm.cr_log2p1(-T(0)) == -T(0)
        # log2p1(−1) returns −∞ and raises the "divide-by-zero" floating-point exception
        @test PureLibm.cr_log2p1(-T(1)) == -T(Inf)
        # log2p1(x) returns a NaN and raises the "invalid" floating-point exception for x < −1
        @test isnan(PureLibm.cr_log2p1(-T(1.1)))
        @test isnan(PureLibm.cr_log2p1(-T(2.0)))
        @test isnan(PureLibm.cr_log2p1(-T(100)))
        @testset "log2p1(x) = NaN, for x < −1" begin
            f_domain = filter(x -> x < -1, float_gen)
            @check log_domain(f = f_domain) = isnan(PureLibm.cr_log2p1(f))
        end
        # log2p1(+∞) returns +∞
        @test PureLibm.cr_log2p1(T(Inf)) == T(Inf)
    end

    @testset "cr_log2p1(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0), T(1), 16)...,
            1:128...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # elseif @likely(ax < 0x3cb7aa26)
                #   |x| < 0x1.6f544cp-6 == 0.02242f0
                rand_float(0f0, 0.02242f0, 128)...,
                0.02242f0,
                # |x| < 0x1.3b3a68p-8 == 0.00481f0
                rand_float(0f0, 0.00481f0, 128)...,
                0.00481f0,
                # - else    x in [0.00481f0, 0.02242f0)
                rand_float(0.00481f0, 0.02242f0, 128)...,
                # |x| < 0x1.c714fcp-13 == 0.000217f0
                rand_float(0f0, 0.000217f0, 128)...,
                0.000217f0,
                # - else    x in [0.000217f0, 0.00481f0)
                rand_float(0.000217f0, 0.00481f0, 128)...,
                # |x| < 0x1.38ac72p-26 == 1.82f-8
                rand_float(0f0, 1.82f-8, 128)...,
                1.82f-8,
                # - else    x in [1.82f-8, 0.000217f0)
                rand_float(1.82f-8, 0.000217f0, 128)...,

                # ---- special cases
                # if @unlikely(ux == 0x32ff7045)
                # x = 2.9736961f-8
                2.9736961f-8,
                # if @unlikely(ux == 0xb395efbb)
                # x= -6.98196f-8
                -6.98196f-8,
                # if @unlikely(ux == 0x35a14df7)
                # x = 1.2018126f-6
                1.2018126f-6,
                # if @unlikely(ux == 0x3841cb81)
                # x = 4.6204314f-5
                4.6204314f-5,
                # if @unlikely(ux == 0xbac9363d)
                # x = -0.0015351247f0
                -0.0015351247f0,
                # if @unlikely(ux == 0x52928e33)
                # x = 3.1472547f11
                3.1472547f11,
                # if @unlikely(ux == 0x4ebd09e3)
                # x = 1.5857709f9
                1.5857709f9,

                # ---- else
                #   x in (-1, -0.02242f0] and [0.02242f0, +Inf)
                rand_float(-0.02242f0, -1f0, 128)...,
                rand_float(0.02242f0, T(Inf), 128)...,
            ])
        end
        @testset "cr_log2p1($(repr(x)))" for x in test_x
            res = PureLibm.cr_log2p1(x)
            # Test against system libm
            # @test res ≈ log2p1_ref(x)
            # Test against MPFR
            @test res === T(log2p1_ref(BigFloat(x)))
        end
    end
end

neg_range = (lo=-Float32(0.0), hi=-Float32(1))
if "cr_log2p1.fast" in CheckExhaustive
    @testset "cr_log2p1-exhaustive.fast (skip)" begin
        @test_broken log2p1(NaN)
        # test_float_range(log2p1_ref, PureLibm.cr_log2p1, neg_range)
        # test_float_range(log2p1_ref, PureLibm.cr_log2p1, F32_POS_RANGE)
    end
end
if "cr_log2p1" in CheckExhaustive
    @testset "cr_log2p1-exhaustive" begin
        test_float_range(log2p1_ref, PureLibm.cr_log2p1, neg_range, bigfloat=true)
        test_float_range(log2p1_ref, PureLibm.cr_log2p1, F32_POS_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log2p1.fast,cr_log2p1"
