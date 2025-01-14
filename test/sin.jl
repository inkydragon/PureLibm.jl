# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sin(::$T)" begin
        # IEC 60559
        # sin(±0) returns ±0
        @test PureLibm.cr_sin(T(0)) == T(0)
        @test PureLibm.cr_sin(-T(0)) == -T(0)
        # sin(±∞) returns a NaN
        @test isnan(PureLibm.cr_sin(T(Inf)))
        @test isnan(PureLibm.cr_sin(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_sin(T(NaN)))
        @test PureLibm.cr_sin(T(pi)/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sin(T(pi)/2) == T(1.0f0)
        @test PureLibm.cr_sin(T(pi)*3/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sin(T(pi)) == T(-8.742278f-8)

    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_sin.fast" in CheckExhaustive
    @testset "cr_sin-exhaustive.fast" begin
        test_float_range(sin, PureLibm.cr_sin, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(sin, PureLibm.cr_sin, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_sin" in CheckExhaustive
    @testset "cr_sin-exhaustive" begin
        test_float_range(sin, PureLibm.cr_sin, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(sin, PureLibm.cr_sin, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ~
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sin.fast,cr_sin"
