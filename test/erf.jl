# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_erf($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_erf(T(NaN)))
        # # erf(±0) returns ±0
        # @test PureLibm.cr_erf(T(0)) == T(0)
        # @test PureLibm.cr_erf(-T(0)) == -T(0)
        # # erf(±∞) returns ±1
        # @test PureLibm.cr_erf(T(Inf)) == T(1)
        # @test PureLibm.cr_erf(-T(Inf)) == -T(1)

    end

    # @testset "cr_erf(rand($T))" begin
    #     test_x = T[
    #         eps(T(0.0)),
    #     ]
    #     @testset "cr_erf($x)" for x in test_x
    #         res = PureLibm.cr_erf(x)
    #         # Test against system libm
    #         @test res ≈ erf(x)
    #         # Test against MPFR
    #         @test res === T(erf(BigFloat(x)))
    #     end
    # end
end
