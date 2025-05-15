# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32]
    @testset "cr_cospi(::$T)" begin
        # IEC 60559
        # cospi(±0) returns 1
        @test PureLibm.cr_cospi(T(0.0)) == T(1.0)
        @test PureLibm.cr_cospi(T(-0.0)) == T(1.0)
        # cospi(n + 1/2) returns +0, for integers n
        for n in rand(1:10^6, 8)
            @test PureLibm.cr_cospi(n + T(0.5)) == T(0.0)
            @test PureLibm.cr_cospi(-n + T(0.5)) == T(0.0)
        end
        # cospi(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_cospi(T(Inf)))
        @test isnan(PureLibm.cr_cospi(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_cospi(T(NaN)))

    end

    # Coverage test
    @testset "cr_cospi(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            
        ]
        @testset "cr_cospi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cospi(x) ≈ cospi(x)
            # Test against MPFR
            @test PureLibm.cr_cospi(x) === T(cospi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_cospi.fast" in CheckExhaustive
    @testset "cr_cospi-exhaustive.fast" begin
        test_float_range(cospi, PureLibm.cr_cospi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(cospi, PureLibm.cr_cospi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_cospi" in CheckExhaustive
    @testset "cr_cospi-exhaustive" begin
        test_float_range(cospi, PureLibm.cr_cospi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(cospi, PureLibm.cr_cospi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cospi.fast,cr_cospi"
