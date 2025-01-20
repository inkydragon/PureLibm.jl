# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_cos(::$T)" begin
        # IEC 60559
        # cos(±0) returns 1
        @test PureLibm.cr_cos(T(0)) == T(1)
        @test PureLibm.cr_cos(-T(0)) == T(1)
        # cos(±∞) returns a NaN
        @test isnan(PureLibm.cr_cos(T(Inf)))
        @test isnan(PureLibm.cr_cos(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_cos(T(NaN)))
        @test PureLibm.cr_cos(T(pi)/4) == sqrt(T(2))/2
        @test PureLibm.cr_cos(T(pi)/2) == T(-4.371139f-8)
        @test PureLibm.cr_cos(T(pi)*3/4) == -sqrt(T(2))/2
        @test PureLibm.cr_cos(T(pi)) == T(-1)
    end

    # Coverage test
    @testset "cr_cos(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            # -pi~pi
            rand_float(Float32(0.0), Float32(pi), 10)...,
            rand_float(-Float32(0.0), -Float32(pi), 10)...,
        ]
        @testset "cr_cos($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cos(x) ≈ cos(x)
            # Test against MPFR
            @test PureLibm.cr_cos(x) === T(cos(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_cos.fast" in CheckExhaustive
    @testset "cr_cos-exhaustive.fast" begin
        test_float_range(cos, PureLibm.cr_cos, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(cos, PureLibm.cr_cos, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_cos" in CheckExhaustive
    @testset "cr_cos-exhaustive" begin
        test_float_range(cos, PureLibm.cr_cos, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(cos, PureLibm.cr_cos, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ~
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cos.fast,cr_cos"
