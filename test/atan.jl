# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atan(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_atan(T(0.0)) == T(0.0)
        @test PureLibm.cr_atan(T(-0.0)) == T(-0.0)
        @test PureLibm.cr_atan(T(Inf)) ≈ pi/2
        @test PureLibm.cr_atan(T(-Inf)) ≈ -pi/2
        @test isnan(PureLibm.cr_atan(T(NaN)))
    
        # sanity check
        @test PureLibm.cr_atan(T(1)) ≈ pi/4
    end
end
