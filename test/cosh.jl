# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_cosh(::$T)" begin
        # IEC 60559
        # cosh(±0) returns 1.
        @test PureLibm.cr_cosh(T(0.0)) == T(1.0)
        @test PureLibm.cr_cosh(-T(0.0)) == T(1.0)
        # cosh(±∞) returns +∞.
        @test PureLibm.cr_cosh(T(Inf)) == T(Inf)
        @test PureLibm.cr_cosh(-T(Inf)) == T(Inf)

        # sanity check
        @test isnan(PureLibm.cr_cosh(T(NaN)))
        @test isnan(PureLibm.cr_cosh(-T(NaN)))
        # overflows
        @test isinf(PureLibm.cr_cosh(Float32(90)))  # cosh(90f0) == Inf32
        @test isinf(PureLibm.cr_cosh(T(711)))       # cosh(711) == Inf64
    end

    # Coverage test
    @testset "cr_cosh(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            # [0, 20]   cosh(20) ~ 2e8
            rand_float(Float32(0.0), Float32(20), 32)...,
            # [20, 89]  cosh(90f0) == Inf32
            rand_float(Float32(20), Float32(89), 16)...,
            89.4,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_cosh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cosh(x) ≈ cosh(x)
            # Test against MPFR
            @test PureLibm.cr_cosh(x) === T(cosh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(711)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-711)))
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
