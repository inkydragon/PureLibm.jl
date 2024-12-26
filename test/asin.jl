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

    @testset "cr_asin(random)" begin
        test_x = T[
            eps(T(0.0)),
            (0.0:0.05:1.0)...,
            # rand(0.0:eps(T):1.0, 10)...,
            # Branch cov
            0.6668132f0, 0.53213656f0,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_asin($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_asin(x) ≈ asin(x)
            # Test against MPFR
            @test PureLibm.cr_asin(x) === T(asin(BigFloat(x)))
        end
    end
end
