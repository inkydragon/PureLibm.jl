# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sincos(::$T)" begin
        # IEC 60559
        # sin(±0) returns ±0
        # cos(±0) returns 1
        @test PureLibm.cr_sincos(T(0)) == (T(0), T(1))
        @test PureLibm.cr_sincos(-T(0)) == (-T(0), T(1))
        # sin(±∞) returns a NaN
        # cos(±∞) returns a NaN
        @test all(isnan.(PureLibm.cr_sincos(T(Inf))))
        @test all(isnan.(PureLibm.cr_sincos(T(-Inf))))

        # sanity check
        @test all(isnan.(PureLibm.cr_sincos(T(NaN))))
        s, c = PureLibm.cr_sincos(T(pi)/4)
        @test s ≈ sqrt(T(2))/2
        @test c == sqrt(T(2))/2
        @test PureLibm.cr_sincos(T(pi)/2) == (T(1.0f0), T(-4.371139f-8))
        s, c = PureLibm.cr_sincos(T(pi)*3/4)
        @test s ≈ sqrt(T(2))/2
        @test c == -sqrt(T(2))/2
        @test PureLibm.cr_sincos(T(pi)) == (T(-8.742278f-8), T(-1))
    end
end
