# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_acosh(::$T)" begin
        # IEC 60559
        # acosh(1) returns +0
        @test PureLibm.cr_acosh(T(1.0)) == T(0.0)
        # acosh(x) returns a NaN and raises the "invalid" floating-point exception for x < 1
        @test isnan(PureLibm.cr_acosh(T(0.9)))
        @test isnan(PureLibm.cr_acosh(T(0.0)))
        @test isnan(PureLibm.cr_acosh(T(-0.0)))
        @test isnan(PureLibm.cr_acosh(T(-0.9)))
        # acosh(+∞) returns +∞
        @test PureLibm.cr_acosh(T(Inf)) == T(Inf)

        # sanity check
        @test isnan(PureLibm.cr_acosh(T(NaN)))

    end

    @testset "cr_acosh(random)" begin
        test_x = T[
 
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_acosh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_acosh(x) ≈ acosh(x)
            # Test against MPFR
            @test PureLibm.cr_acosh(x) === T(acosh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(1.0)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-1.0)))
if "cr_acosh.fast" in CheckExhaustive
    @testset "cr_acosh-exhaustive.fast" begin
        test_float_range(acosh, PureLibm.cr_acosh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(acosh, PureLibm.cr_acosh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_acosh" in CheckExhaustive
    @testset "cr_acosh-exhaustive" begin
        test_float_range(acosh, PureLibm.cr_acosh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(acosh, PureLibm.cr_acosh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_acosh.fast,cr_acosh"
