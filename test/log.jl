# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_log(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
        # log Domain
        @testset "log(x) >= 0, for x >= 1" begin
            f_domain = filter(x -> x >= 1, float_gen)
            @check log_domain(f = f_domain) = 0 <= PureLibm.cr_log(f)
        end
        @testset "log(x) <= 0, for 0 < x <= 1" begin
            f_domain = filter(x -> 0 < x <= 1, float_gen)
            @check log_domain(f = f_domain) = PureLibm.cr_log(f) <= 0
        end

        # IEC 60559
        @test isnan(PureLibm.cr_log(T(NaN)))
        # log(±0) returns −∞ and raises the "divide-by-zero" floating-point exception
        @test PureLibm.cr_log(T(+0.0)) == T(-Inf)
        @test PureLibm.cr_log(T(-0.0)) == T(-Inf)
        # log(1) returns +0
        @test PureLibm.cr_log(T(1)) == T(0)
        # log(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0.
        @test isnan(PureLibm.cr_log(prevfloat(T(-0.0))))
        @test isnan(PureLibm.cr_log(T(-2)))
        @test isnan(PureLibm.cr_log(T(-1024)))
        @test isnan(PureLibm.cr_log(T(-Inf)))
        @testset "log(x) = NaN, for x < 0" begin
            f_domain = filter(x -> x < 0, float_gen)
            @check log_domain(f = f_domain) = isnan(PureLibm.cr_log(f))
        end
        # log(+∞) returns +∞
        @test PureLibm.cr_log(T(Inf)) == T(Inf)

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

if "cr_log.fast" in CheckExhaustive
    @testset "cr_log-exhaustive.fast" begin
        test_float_range(log, PureLibm.cr_log, F32_POS_RANGE)
    end
end
if "cr_log" in CheckExhaustive
    @testset "cr_log-exhaustive" begin
        test_float_range(log, PureLibm.cr_log, F32_POS_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log.fast,cr_log"
