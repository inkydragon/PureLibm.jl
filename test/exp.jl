# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_exp(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_exp(T(0.0)) == T(1)
        @test PureLibm.cr_exp(T(-0.0)) == T(1)
        @test PureLibm.cr_exp(T(-Inf)) == T(0)
        @test PureLibm.cr_exp(T(Inf)) == T(Inf)

        @test isnan(PureLibm.cr_exp(T(NaN)))
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(89))
neg_range = (lo=Float32(-0.0), hi=Float32(-104))
if "cr_exp.fast" in CheckExhaustive
    @testset "cr_exp-exhaustive.fast" begin
        test_float_range(exp, PureLibm.cr_exp, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(exp, PureLibm.cr_exp, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_exp" in CheckExhaustive
    @testset "cr_exp-exhaustive" begin
        test_float_range(exp, PureLibm.cr_exp, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(exp, PureLibm.cr_exp, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ~ 20s / 65min
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp.fast,cr_exp"
