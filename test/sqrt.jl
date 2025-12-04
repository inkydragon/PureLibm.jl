# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_sqrt($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)

        # IEC 60559
        @test isnan(PureLibm.cr_sqrt(T(NaN)))
        # sqrt(±0) returns ±0
        @test PureLibm.cr_sqrt(T(0.0)) == T(0.0)
        @test PureLibm.cr_sqrt(T(-0.0)) == -T(0.0)
        # sqrt(+∞) returns +∞
        @test PureLibm.cr_sqrt(T(Inf)) == T(Inf)
        # sqrt(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0
        # @test isnan(PureLibm.cr_sqrt(T(-1.0)))
        # @test isnan(PureLibm.cr_sqrt(T(-Inf)))
        # @testset "sqrt(x) = NaN, for x < 0" begin
        #     f_domain = filter(x -> x < 0, float_gen)
        #     @check sqrt_domain(f = f_domain) = isnan(PureLibm.cr_sqrt(f))
        # end
    end

    @testset "cr_sqrt(random)" begin
        test_x = T[
            eps(T(0.0)),
            (i^2 for i in 1:128)...,
        ]
        @testset "cr_sqrt($(repr(x)))" for x in test_x
            # Test against system libm
            @test PureLibm.cr_sqrt(x) ≈ sqrt(x)
            # Test against MPFR
            @test PureLibm.cr_sqrt(x) === T(sqrt(BigFloat(x)))
        end
    end
end

if "cr_sqrt.fast" in CheckExhaustive
    @testset "cr_sqrt-exhaustive.fast" begin
        test_float_range(sqrt, PureLibm.cr_sqrt, F32_POS_RANGE)
    end
end
if "cr_sqrt" in CheckExhaustive
    @testset "cr_sqrt-exhaustive" begin
        test_float_range(sqrt, PureLibm.cr_sqrt, F32_POS_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sqrt.fast,cr_sqrt"
