# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_cosh(::$T)" begin
        # IEC 60559

        # sanity check

    end

    # Coverage test
    @testset "cr_cosh(rand($T))" begin
        test_x = T[
            eps(T(0.0)),

        ]
        @testset "cr_cosh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cosh(x) ≈ cosh(x)
            # Test against MPFR
            @test PureLibm.cr_cosh(x) === T(cosh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_cosh.fast" in CheckExhaustive
    @testset "cr_cosh-exhaustive.fast" begin
        test_float_range(cosh, PureLibm.cr_cosh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(cosh, PureLibm.cr_cosh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_cosh" in CheckExhaustive
    @testset "cr_cosh-exhaustive" begin
        test_float_range(cosh, PureLibm.cr_cosh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(cosh, PureLibm.cr_cosh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cosh.fast,cr_cosh"
