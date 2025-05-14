# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_expm1(::$T)" begin
        # IEC 60559
        # expm1(±0) returns ±0.
        @test PureLibm.cr_expm1(zero(T)) == zero(T)
        @test PureLibm.cr_expm1(-zero(T)) == -zero(T)
        # expm1(−∞) returns −1.
        @test PureLibm.cr_expm1(-T(Inf)) == -one(T)
        # expm1(+∞) returns +∞.
        @test PureLibm.cr_expm1(T(Inf)) == T(Inf)

        # sanity check
        @test isnan(PureLibm.cr_expm1(T(NaN)))
        @test PureLibm.cr_expm1(T(1)) ≈ T(ℯ - 1.0)
        # overflow
        @test PureLibm.cr_expm1(89f0) == Inf32      # expm1(89f0) == Inf32
        @test PureLibm.cr_expm1(T(710)) == T(Inf)   # expm1(710) == Inf64
        # underflow
        @test PureLibm.cr_expm1(-17.4f0) == -one(T)
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(Inf))
neg_range = (lo=Float32(-0.0), hi=Float32(-Inf))
if "cr_expm1.fast" in CheckExhaustive
    @testset "cr_expm1-exhaustive.fast" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_expm1" in CheckExhaustive
    @testset "cr_expm1-exhaustive" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_expm1.fast,cr_expm1"
