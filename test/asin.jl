# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_asin(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_asin(T(0.0)) == T(0.0)
        @test PureLibm.cr_asin(T(-0.0)) == T(-0.0)
        # |x| > 1
        @test isnan(PureLibm.cr_asin(T(2)))
        @test isnan(PureLibm.cr_asin(T(-2)))
        @test isnan(PureLibm.cr_asin(T(Inf)))
        @test isnan(PureLibm.cr_asin(T(-Inf)))
        @test isnan(PureLibm.cr_asin(T(NaN)))
    
        # sanity check
        @test PureLibm.cr_asin(T(1.0)) * 2 ≈ pi
        @test PureLibm.cr_asin(T(-0.5)) * 6 ≈ -pi
    end
end
