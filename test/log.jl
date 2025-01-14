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
            # @test PureLibm.cr_log(prevfloat(T(2.9802322f-8))) == T(2.980232f-8)
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
# ~ 
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log.fast,cr_log"
