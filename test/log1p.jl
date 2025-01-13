# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_log1p(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_log1p(T(+0.0)) == T(+0.0)
        @test PureLibm.cr_log1p(T(-0.0)) == T(-0.0)
        @test PureLibm.cr_log1p(T(-1)) == T(-Inf)
        # x < -1, log1p(x) == NaN
        @test isnan(PureLibm.cr_log1p(prevfloat(T(-1))))
        @test isnan(PureLibm.cr_log1p(T(-2)))
        @test isnan(PureLibm.cr_log1p(T(-1024)))
        @test isnan(PureLibm.cr_log1p(T(-Inf)))
        @test PureLibm.cr_log1p(T(Inf)) == T(Inf)

        @test isnan(PureLibm.cr_log1p(T(NaN)))

        # Coverage
    end
end

neg_range = (lo=Float32(-0.0), hi=Float32(-1))
pos_range = (lo=Float32(+0.0), hi=prevfloat(Float32(Inf)))
if "cr_log1p.fast" in CheckExhaustive
    @testset "cr_log1p-exhaustive.fast" begin
        test_float_range(log1p, PureLibm.cr_log1p, lo=neg_range.lo, hi=neg_range.hi)
        test_float_range(log1p, PureLibm.cr_log1p, lo=pos_range.lo, hi=pos_range.hi)
    end
end
if "cr_log1p" in CheckExhaustive
    @testset "cr_log1p-exhaustive" begin
        test_float_range(log1p, PureLibm.cr_log1p, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
        test_float_range(log1p, PureLibm.cr_log1p, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
    end
end
# ~ 23s / 
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log1p.fast,cr_log1p"
