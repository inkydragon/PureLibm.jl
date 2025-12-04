# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_exp(::$T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_exp(T(NaN)))
        # exp(±0) returns 1
        @test PureLibm.cr_exp(T(0.0)) == T(1)
        @test PureLibm.cr_exp(T(-0.0)) == T(1)
        # exp(−∞) returns +0
        @test PureLibm.cr_exp(T(-Inf)) == T(0)
        # exp(+∞) returns +∞
        @test PureLibm.cr_exp(T(Inf)) == T(Inf)

        # Coverage
        @test PureLibm.cr_exp(T(1)) == T(Base.MathConstants.e)
        @test PureLibm.cr_exp(T(-1)) == 1/T(Base.MathConstants.e)
        if Float32 == T
            # NOTE: for f32 (-103.27881f0, 88.72283f0)
            @test PureLibm.cr_exp(T(-104)) == T(0)
            @test PureLibm.cr_exp(T(89)) == T(Inf)
            # if @unlikely(ub != lb)
            @test PureLibm.cr_exp(T(0.010941569f0)) == T(1.0110017f0)
            @test PureLibm.cr_exp(T(-2.613688f-5)) == T(0.9999739f0)
        else
            nothing
        end
    end
end

pos_range = (lo=+Float32(0.0), hi=+Float32(89))
neg_range = (lo=-Float32(0.0), hi=-Float32(104))
if "cr_exp.fast" in CheckExhaustive
    @testset "cr_exp-exhaustive.fast" begin
        test_float_range(exp, PureLibm.cr_exp, pos_range)
        test_float_range(exp, PureLibm.cr_exp, neg_range)
    end
end
if "cr_exp" in CheckExhaustive
    @testset "cr_exp-exhaustive" begin
        test_float_range(exp, PureLibm.cr_exp, pos_range, bigfloat=true)
        test_float_range(exp, PureLibm.cr_exp, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp.fast,cr_exp"
