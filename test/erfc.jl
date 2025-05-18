# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_erfc($T)" begin
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

# pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
# neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
# if "cr_erfc.fast" in CheckExhaustive
#     @testset "cr_erfc-exhaustive.fast" begin
#         test_float_range(erfc, PureLibm.cr_erfc, lo=pos_range.lo, hi=pos_range.hi)
#         test_float_range(erfc, PureLibm.cr_erfc, lo=neg_range.lo, hi=neg_range.hi)
#     end
# end
# if "cr_erfc" in CheckExhaustive
#     @testset "cr_erfc-exhaustive" begin
#         test_float_range(erfc, PureLibm.cr_erfc, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
#         test_float_range(erfc, PureLibm.cr_erfc, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
#     end
# end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_erfc.fast,cr_erfc"
