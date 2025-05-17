# SPDX-License-Identifier: MIT OR Apache-2.0

# ref
_asinpi(x::T) where {T<:AbstractFloat} = T(asin(x) / pi)

for T in [Float32, ]
    @testset "cr_asin(::$T)" begin
        # IEC 60559

        # sanity check

    end

    @testset "cr_asin(random)" begin
        test_x = T[
            eps(T(0.0)),

        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_asin($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_asin(x) ≈ _asinpi(x)
            # Test against MPFR
            @test PureLibm.cr_asin(x) === T(_asinpi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(1.0)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-1.0)))
if "cr_asin.fast" in CheckExhaustive
    @testset "cr_asin-exhaustive.fast" begin
        test_float_range(_asinpi, PureLibm.cr_asin, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(_asinpi, PureLibm.cr_asin, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_asin" in CheckExhaustive
    @testset "cr_asin-exhaustive" begin
        test_float_range(_asinpi, PureLibm.cr_asin, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(_asinpi, PureLibm.cr_asin, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_asin.fast,cr_asin"
