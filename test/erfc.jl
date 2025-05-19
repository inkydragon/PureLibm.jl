# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_erfc($T)" begin
        @test_throws ErrorException PureLibm.cr_erfc(T(1.0))
        # IEC 60559
        # @test isnan(PureLibm.cr_erfc(T(NaN)))
        # # erfc(−∞) returns 2
        # @test PureLibm.cr_erfc(T(-Inf)) == T(2)
        # # erfc(+∞) returns +0
        # @test PureLibm.cr_erfc(T(Inf)) == T(0)

    end

    # @testset "cr_erfc(rand($T))" begin
    #     test_x = T[
    #         eps(T(0.0)),
    #     ]
    #     @testset "cr_erfc($x)" for x in test_x
    #         res = PureLibm.cr_erfc(x)
    #         # Test against system libm
    #         @test res ≈ erfc(x)
    #         # Test against MPFR
    #         @test res === T(erfc(BigFloat(x)))
    #     end
    # end
end
