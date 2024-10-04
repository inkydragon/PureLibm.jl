# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "acos(::$T)" begin
        # IEC 60559
        @test PureLibm.acos(T(1)) == T(0)
        @test isnan(PureLibm.acos(T(2)))
        @test isnan(PureLibm.acos(T(-2)))
        @test isnan(PureLibm.acos(T(Inf)))
        @test isnan(PureLibm.acos(T(-Inf)))
        @test isnan(PureLibm.acos(T(NaN)))
    
        # sanity check
        @test PureLibm.acos(T(-1)) ≈ pi
        @test PureLibm.acos(T(0)) * 2 ≈ pi
        @test PureLibm.acos(T(0.5)) * 3 ≈ pi
    end
end
