# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_exp10m1($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_exp10m1(T(NaN)))
        # # exp10m1(±0) returns ±0
        # @test PureLibm.cr_exp10m1(T(0.0)) == T(0)
        # @test PureLibm.cr_exp10m1(-T(0.0)) == -T(0)
        # # exp10m1(−∞) returns -1
        # @test PureLibm.cr_exp10m1(-T(Inf)) == -T(1)
        # # exp10m1(+∞) returns +∞
        # @test PureLibm.cr_exp10m1(T(Inf)) == T(Inf)
    end
end

# pos_range = (lo=Float32(0.0), hi=Float32(Inf))
# neg_range = (lo=Float32(-0.0), hi=Float32(-Inf))
# if "cr_exp10m1.fast" in CheckExhaustive
#     @testset "cr_exp10m1-exhaustive.fast" begin
#         test_float_range(exp10m1, PureLibm.cr_exp10m1, lo=pos_range.lo, hi=pos_range.hi)
#         test_float_range(exp10m1, PureLibm.cr_exp10m1, lo=neg_range.lo, hi=neg_range.hi)
#     end
# end
# if "cr_exp10m1" in CheckExhaustive
#     @testset "cr_exp10m1-exhaustive" begin
#         test_float_range(exp10m1, PureLibm.cr_exp10m1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
#         test_float_range(exp10m1, PureLibm.cr_exp10m1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
#     end
# end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp10m1.fast,cr_exp10m1"
