# SPDX-License-Identifier: MIT OR Apache-2.0

ref_rsqrt(x::T) where {T<:AbstractFloat} = T(1) / sqrt(x)

for T in [Float32, Float64]
    @testset "cr_rsqrt($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
 
        # IEC 60559
        @test isnan(PureLibm.cr_rsqrt(T(NaN)))
        @test isnan(PureLibm.cr_rsqrt(T(-NaN)))
        # rSqrt(±0) is ±∞ and signals the divideByZero exception.
        @test PureLibm.cr_rsqrt(T(+0.0)) === T(+Inf)
        @test PureLibm.cr_rsqrt(T(-0.0)) === T(-Inf)
        # rsqrt(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0.
        @test isnan(PureLibm.cr_rsqrt(T(-1)))
        @test isnan(PureLibm.cr_rsqrt(T(-Inf)))
        @testset "rsqrt(x) = NaN, for x < 0" begin
            f_domain = filter(x -> x < 0, float_gen)
            @check rsqrt_domain(f = f_domain) = isnan(PureLibm.cr_rsqrt(f))
        end
        # rSqrt(+∞) is +0 with no exception. 
        @test PureLibm.cr_rsqrt(T(+Inf)) === T(+0.0)

        # sanity check
        @test PureLibm.cr_rsqrt(T(1)) ≈ T(1)
        @test PureLibm.cr_rsqrt(T(4)) ≈ T(0.5)
    end

    @testset "cr_rsqrt(random)" begin
        test_x = T[
            (0.0:0.1:5.0)...,
            rand(0.0:eps():1.0, 10)...,
            # Branch cov
            # ixu < (UInt64(1) << 52) && ixu != 0
            eps(T(0.0)),
        ]
        @testset "cr_rsqrt($x)" for x in test_x
            if x < 0
                @test PureLibm.cr_rsqrt(x) === -T(NaN)
                continue
            end

            # Test against system libm
            @test PureLibm.cr_rsqrt(x) ≈ ref_rsqrt(x)
            # Test against MPFR
            @test PureLibm.cr_rsqrt(x) === T(ref_rsqrt(BigFloat(x)))
        end
    end
end

@testset "cr_rsqrt.special-case" begin
    test_x = Float32[
        # Special Cases
        4.361527f-39,
        1.744611f-38,
        1.2625759f38,
        7.87193f-39,
        2.8407959f38,
    ]
    test_x = [test_x..., -test_x...]
    @testset "cr_rsqrt($x)" for x in test_x
        if x < 0
            @test PureLibm.cr_rsqrt(x) === -NaN32
            continue
        end

        # Test against system libm
        @test PureLibm.cr_rsqrt(x) ≈ 1/sqrt(x)
        # Test against MPFR
        @test PureLibm.cr_rsqrt(x) === Float32(1/sqrt(BigFloat(x)))
    end
end

if "cr_rsqrt.fast" in CheckExhaustive
    @testset "cr_rsqrt-exhaustive.fast" begin
        test_float_range(ref_rsqrt, PureLibm.cr_rsqrt, F32_POS_RANGE)
    end
end
if "cr_rsqrt" in CheckExhaustive
    @testset "cr_rsqrt-exhaustive" begin
        test_float_range(ref_rsqrt, PureLibm.cr_rsqrt, F32_POS_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_rsqrt.fast,cr_rsqrt"
