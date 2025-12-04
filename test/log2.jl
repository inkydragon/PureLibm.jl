# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log2($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
        # log2 Domain
        @testset "log2(x) >= 0, for x >= 1" begin
            f_domain = filter(x -> x >= 1, float_gen)
            @check log2_domain(f = f_domain) = 0 <= PureLibm.cr_log2(f)
        end
        @testset "log2(x) <= 0, for 0 < x <= 1" begin
            f_domain = filter(x -> 0 < x <= 1, float_gen)
            @check log2_domain(f = f_domain) = PureLibm.cr_log2(f) <= 0
        end

        # IEC 60559
        @test isnan(PureLibm.cr_log2(T(NaN)))
        # log2(±0) returns −∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_log2(T(0.0)) == -T(Inf)
        @test PureLibm.cr_log2(T(-0.0)) == -T(Inf)
        # log2(1) returns +0.
        @test PureLibm.cr_log2(T(1)) == T(0.0)
        # log2(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0.
        @test isnan(PureLibm.cr_log2(T(-0.1)))
        @test isnan(PureLibm.cr_log2(T(-1)))
        @test isnan(PureLibm.cr_log2(T(-Inf)))
        @testset "log2(x) = NaN, for x < 0" begin
            f_domain = filter(x -> x < 0, float_gen)
            @check log_domain(f = f_domain) = isnan(PureLibm.cr_log2(f))
        end
        # log2(+∞) returns +∞.
        @test PureLibm.cr_log2(T(Inf)) == T(Inf)

        # sanity check
        @test PureLibm.cr_log2(T(2)) == T(1)
        @test PureLibm.cr_log2(1/T(2)) == T(-1)
    end

    @testset "cr_log2(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 64)...,
            rand_float(T(1.0), T(prevfloat(Float32(Inf))), 64)...,

            # branch coverage
            # (m == 0)
            0.5f0,
            1.0f0,
            2.0f0,
        ]
        @testset "cr_log2($x)" for x in test_x
            res = PureLibm.cr_log2(x)
            # Test against system libm
            @test res ≈ log2(x)
            # Test against MPFR
            @test res === T(log2(BigFloat(x)))
        end
    end
end

if "cr_log2.fast" in CheckExhaustive
    @testset "cr_log2-exhaustive.fast" begin
        test_float_range(log2, PureLibm.cr_log2, F32_POS_RANGE)
    end
end
if "cr_log2" in CheckExhaustive
    @testset "cr_log2-exhaustive" begin
        test_float_range(log2, PureLibm.cr_log2, F32_POS_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log2.fast,cr_log2"
