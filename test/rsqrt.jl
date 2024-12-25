# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, Float64]
    @testset "cr_rsqrt(::$T)" begin
        # IEC 60559
        # rSqrt(+∞) is +0 with no exception. 
        @test PureLibm.cr_rsqrt(T(+Inf)) === T(+0.0)
        # rSqrt(±0) is ±∞ and signals the divideByZero exception.
        @test PureLibm.cr_rsqrt(T(+0.0)) === T(+Inf)
        @test PureLibm.cr_rsqrt(T(-0.0)) === T(-Inf)
        @test PureLibm.cr_rsqrt(T(NaN)) === T(NaN)
        @test PureLibm.cr_rsqrt(T(-NaN)) === -T(NaN)

        # sanity check
        @test PureLibm.cr_rsqrt(T(-1)) === -T(NaN)
        @test PureLibm.cr_rsqrt(T(-Inf)) === -T(NaN)
        @test PureLibm.cr_rsqrt(T(1)) ≈ T(1)
        @test PureLibm.cr_rsqrt(T(4)) ≈ T(0.5)
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
