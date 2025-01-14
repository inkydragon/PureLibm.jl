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
        if Float32 == T
            # if @unlikely(ax < 0x33000000)  # |x| < 2.9802322f-8
            @test PureLibm.cr_log1p(prevfloat(T(2.9802322f-8))) == T(2.980232f-8)
            @test PureLibm.cr_log1p(-prevfloat(T(2.9802322f-8))) == -T(2.980232f-8)
            # if @likely(ax < 0x3c880000)  # |x| < 0.016601562f0
            @test PureLibm.cr_log1p(T(2.9802322f-8)) == T(2.9802322f-8)
            @test PureLibm.cr_log1p(prevfloat(T(0.016601562f0))) == T(0.016465262f0)
            # if @unlikely((ru & UInt64(0x0fff_ffff)) == 0)
            @test PureLibm.cr_log1p(T(1.1444135f-5)) == T(1.144407f-5)
            @test PureLibm.cr_log1p(T(-7.1525557f-7)) == T(-7.152558f-7)
            # else
            # if @unlikely(ub != lb)
            # if @unlikely((tru & UInt64(0x0fff_ffff)) == 0)
            @test PureLibm.cr_log1p(T(-0x1.247ab0p-6)) == T(-0.018012777f0)
            @test PureLibm.cr_log1p(T(-0x1.3a415ep-5)) == T(-0.039116416f0)
            @test PureLibm.cr_log1p(T(0x1.fb035ap-2)) == T(0.40221313f0)
            @test PureLibm.cr_log1p(T(0.372202f0)) == T(0.31641674f0)
            @test PureLibm.cr_log1p(T(5.498306f28)) == T(66.17683f0)
            # elseif (rl + (Lh - trf)) == 0
            @test PureLibm.cr_log1p(T(0x1.b7fd86p-4)) == T(0.10203255f0)
            @test PureLibm.cr_log1p(T(-0x1.3a415ep-5)) == T(-0.039116416f0)
            @test PureLibm.cr_log1p(T(0x1.43c7e2p-6)) == T(0.019569278f0)
        else
            nothing
        end
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
# ~ 23s / 128min
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log1p.fast,cr_log1p"
