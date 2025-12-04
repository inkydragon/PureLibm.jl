# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_exp10(::$T)" begin
        # IEC 60559
        # exp10(±0) returns 1
        @test PureLibm.cr_exp10(T(0.0)) == T(1)
        @test PureLibm.cr_exp10(T(-0.0)) == T(1)
        # exp10(−∞) returns +0
        @test PureLibm.cr_exp10(T(-Inf)) == T(0)
        # exp10(+∞) returns +∞
        @test PureLibm.cr_exp10(T(Inf)) == T(Inf)

        @test isnan(PureLibm.cr_exp10(T(NaN)))

        # Coverage
        @test PureLibm.cr_exp10(T(1)) == T(10)
        @test PureLibm.cr_exp10(T(3)) == T(1000)
        @test PureLibm.cr_exp10(T(-1)) == 1/T(10)
        if Float32 == T
            # if tu > 0xc23369f4
            @test PureLibm.cr_exp10(T(-44.9)) == T(1.0f-45)
            @test PureLibm.cr_exp10(T(-50)) == T(0.0)
            # if tu < 0x80000000
            @test PureLibm.cr_exp10(T(38.6)) == T(Inf)
            @test PureLibm.cr_exp10(T(40)) == T(Inf)
            # if @unlikely(ub != lb)
            @test PureLibm.cr_exp10(T(0.00034665596f0)) == T(1.0007986f0)
            @test PureLibm.cr_exp10(T(1.6168841f0)) == T(41.388924f0)
        end
    end
end

pos_range = (lo=+Float32(0.0), hi=+Float32(39)) # 38.531837f0
neg_range = (lo=-Float32(0.0), hi=-Float32(46)) # -44.85347f0
if "cr_exp10.fast" in CheckExhaustive
    @testset "cr_exp10-exhaustive.fast" begin
        test_float_range(exp10, PureLibm.cr_exp10, pos_range)
        test_float_range(exp10, PureLibm.cr_exp10, neg_range)
    end
end
if "cr_exp10" in CheckExhaustive
    @testset "cr_exp10-exhaustive" begin
        test_float_range(exp10, PureLibm.cr_exp10, pos_range, bigfloat=true)
        test_float_range(exp10, PureLibm.cr_exp10, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_exp10.fast,cr_exp10"
