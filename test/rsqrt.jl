# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, Float64]
    @testset "rsqrt(::$T)" begin
        # IEC 60559
        # rSqrt(+∞) is +0 with no exception. 
        @test PureLibm.rsqrt(T(+Inf)) ≈ T(+0.0)
        # rSqrt(±0) is ±∞ and signals the divideByZero exception.
        @test PureLibm.rsqrt(T(+0.0)) ≈ T(+Inf)
        @test PureLibm.rsqrt(T(-0.0)) ≈ T(-Inf)
        @test isnan(PureLibm.rsqrt(T(NaN)))

        # sanity check
        @test isnan(PureLibm.rsqrt(T(-1)))
        @test isnan(PureLibm.rsqrt(T(-Inf)))
        @test PureLibm.rsqrt(T(1)) ≈ T(1)
        @test PureLibm.rsqrt(T(4)) ≈ T(0.5)
    end
end
