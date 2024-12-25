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
