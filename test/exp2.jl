# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_exp2(::$T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_exp2(T(NaN)))
        # exp2(±0) returns 1
        @test PureLibm.cr_exp2(T(0.0)) == T(1)
        @test PureLibm.cr_exp2(T(-0.0)) == T(1)
        # exp2(−∞) returns +0
        @test PureLibm.cr_exp2(T(-Inf)) == T(0)
        # exp2(+∞) returns +∞
        @test PureLibm.cr_exp2(T(Inf)) == T(Inf)

        # Coverage
        @test PureLibm.cr_exp2(T(1)) == T(2)
        @test PureLibm.cr_exp2(T(-1)) == 1/T(2)
        if Float32 == T
            # elseif m <= 0 && m > -23
            @test PureLibm.cr_exp2(T(-127)) == T(5.877472f-39)
            # _exp2f_as_special
            @test PureLibm.cr_exp2(T(-150)) == T(0)
            @test PureLibm.cr_exp2(T(128)) == T(Inf)

            # if @unlikely(ub != lb)
            @test PureLibm.cr_exp2(T(0.0029695758f0)) == T(1.0020605f0)
            @test PureLibm.cr_exp2(T(-0.029743774f0)) == T(0.9795943f0)
            @test PureLibm.cr_exp2(T(-0.00010100035f0)) == T(0.99992996f0)
            # not (ux <= 0x79e7526e)
            @test PureLibm.cr_exp2(T(0.0020340662f0)) == T(1.001411f0)
            @test PureLibm.cr_exp2(T(0.0021075692f0)) == T(1.001462f0)
        else
            nothing
        end
    end
end

pos_range = (lo=+Float32(0.0), hi=+Float32(128))
neg_range = (lo=-Float32(0.0), hi=-Float32(150))
if "cr_exp2.fast" in CheckExhaustive
    @testset "cr_exp2-exhaustive.fast" begin
        test_float_range(exp2, PureLibm.cr_exp2, pos_range)
        test_float_range(exp2, PureLibm.cr_exp2, neg_range)
    end
end
if "cr_exp2" in CheckExhaustive
    @testset "cr_exp2-exhaustive" begin
        test_float_range(exp2, PureLibm.cr_exp2, pos_range, bigfloat=true)
        test_float_range(exp2, PureLibm.cr_exp2, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp2.fast,cr_exp2"
