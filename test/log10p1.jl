# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log10p1($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_log10p1(T(NaN)))
        # # log10p1(±0) returns ±0
        # @test PureLibm.cr_log10p1(T(0)) == T(0)
        # @test PureLibm.cr_log10p1(-T(0)) == -T(0)
        # # log10p1(−1) returns −∞ and raises the "divide-by-zero" floating-point exception
        # @test PureLibm.cr_log10p1(-T(1)) == -T(Inf)
        # # log10p1(x) returns a NaN and raises the "invalid" floating-point exception
        # #   for x < −1
        # @test isnan(PureLibm.cr_log10p1(-T(1.1)))
        # @test isnan(PureLibm.cr_log10p1(-T(2.0)))
        # @test isnan(PureLibm.cr_log10p1(-T(100)))
        # # log10p1(+∞) returns +∞
        # @test PureLibm.cr_log10p1(T(Inf)) == T(Inf)

    end

    # @testset "cr_log10p1(rand($T))" begin
    #     test_x = T[
    #         eps(T(0.0)),

    #     ]
    #     @testset "cr_log10p1($x)" for x in test_x
    #         res = PureLibm.cr_log10p1(x)
    #         # Test against system libm
    #         @test res ≈ log10p1(x)
    #         # Test against MPFR
    #         @test res === T(log10p1(BigFloat(x)))
    #     end
    # end
end
