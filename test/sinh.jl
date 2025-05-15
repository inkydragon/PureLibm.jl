# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sinh(::$T)" begin
        # IEC 60559
        # sinh(±0) returns ±0
        @test PureLibm.cr_sinh(T(0.0)) == T(0.0)
        @test PureLibm.cr_sinh(T(-0.0)) == T(-0.0)
        # sinh(±∞) returns ±∞
        @test PureLibm.cr_sinh(T(Inf)) == T(Inf)
        @test PureLibm.cr_sinh(T(-Inf)) == T(-Inf)

        # sanity check

    end

    # Coverage test
    @testset "cr_sinh(random)" begin
        test_x = T[
            eps(T(0.0)),

        ]
        @testset "cr_sinh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_sinh(x) ≈ sinh(x)
            # Test against MPFR
            @test PureLibm.cr_sinh(x) === T(sinh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_sinh.fast" in CheckExhaustive
    @testset "cr_sinh-exhaustive.fast" begin
        test_float_range(sinh, PureLibm.cr_sinh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(sinh, PureLibm.cr_sinh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_sinh" in CheckExhaustive
    @testset "cr_sinh-exhaustive" begin
        test_float_range(sinh, PureLibm.cr_sinh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(sinh, PureLibm.cr_sinh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sinh.fast,cr_sinh"
