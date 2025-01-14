# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_log(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_log(T(+0.0)) == T(-Inf)
        @test PureLibm.cr_log(T(-0.0)) == T(-Inf)
        @test PureLibm.cr_log(T(1)) == T(0)
        # x < 0, log(x) == NaN
        @test isnan(PureLibm.cr_log(prevfloat(T(-0.0))))
        @test isnan(PureLibm.cr_log(T(-2)))
        @test isnan(PureLibm.cr_log(T(-1024)))
        @test isnan(PureLibm.cr_log(T(-Inf)))
        @test PureLibm.cr_log(T(Inf)) == T(Inf)

        @test isnan(PureLibm.cr_log(T(NaN)))

        # Coverage
        if Float32 == T
            # subnormal
            @test PureLibm.cr_log(T(0x1p-128)) == T(-88.72284f0)
            @test PureLibm.cr_log(T(0x1p-134)) == T(-92.88172f0)
            @test PureLibm.cr_log(T(0x1p-142)) == T(-98.4269f0)
            # normal path
            @test PureLibm.cr_log(T(Base.MathConstants.e)) == T(0.99999994f0)
            @test PureLibm.cr_log(1/T(Base.MathConstants.e)) == T(-1.0f0)
            # acc path:  if @unlikely(ub != lb)
            @test PureLibm.cr_log(T(3.2283728f-37)) == T(-84.023674f0)
            # if @unlikely(abs(x - 1.0) < 0x1p-10)
            @test PureLibm.cr_log(T(0.999856f0)) == T(-0.0001440152f0)
        end
    end
end

pos_range = (lo=Float32(+0.0), hi=Float32(Inf))
if "cr_log.fast" in CheckExhaustive
    @testset "cr_log-exhaustive.fast" begin
        test_float_range(log, PureLibm.cr_log, lo=pos_range.lo, hi=pos_range.hi)
    end
end
if "cr_log" in CheckExhaustive
    @testset "cr_log-exhaustive" begin
        test_float_range(log, PureLibm.cr_log, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
    end
end
# ~ 27s / 
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log.fast,cr_log"
