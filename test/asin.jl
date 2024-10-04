# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "asin(::$T)" begin
        # IEC 60559
        @test PureLibm.asin(T(0.0)) == T(0.0)
        @test PureLibm.asin(T(-0.0)) == T(-0.0)
        # |x| > 1
        @test isnan(PureLibm.asin(T(2)))
        @test isnan(PureLibm.asin(T(-2)))
        @test isnan(PureLibm.asin(T(Inf)))
        @test isnan(PureLibm.asin(T(-Inf)))
        @test isnan(PureLibm.asin(T(NaN)))
    
        # sanity check
        @test PureLibm.asin(T(1.0)) * 2 ≈ pi
        @test PureLibm.asin(T(-0.5)) * 6 ≈ -pi
    end
end
