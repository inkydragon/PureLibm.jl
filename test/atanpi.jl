# SPDX-License-Identifier: MIT OR Apache-2.0

# ref
_atanpi(x::T) where {T<:AbstractFloat} = T(atan(x) / pi)

for T in [Float32, ]
    @testset "cr_atanpi($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_atanpi(T(NaN)))
        # atanpi(±0) returns ±0
        @test PureLibm.cr_atanpi(T(0.0)) == T(0.0)
        @test PureLibm.cr_atanpi(T(-0.0)) == T(-0.0)
        # atanpi(±∞) returns ±1/2
        @test PureLibm.cr_atanpi(T(Inf)) == 1/2
        @test PureLibm.cr_atanpi(T(-Inf)) == -1/2

        # sanity check
        @test PureLibm.cr_atanpi(T(1)) == T(1/4)
        @test PureLibm.cr_atanpi(-T(1)) == -T(1/4)
    end

    @testset "cr_atanpi(random)" begin
        test_x = T[
            eps(T(0.0)),
 
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_atanpi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_atanpi(x) ≈ _atanpi(x)
            # Test against MPFR
            @test PureLibm.cr_atanpi(x) === T(_atanpi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_atanpi.fast" in CheckExhaustive
    @testset "cr_atanpi-exhaustive.fast" begin
        test_float_range(_atanpi, PureLibm.cr_atanpi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(_atanpi, PureLibm.cr_atanpi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_atanpi" in CheckExhaustive
    @testset "cr_atanpi-exhaustive" begin
        test_float_range(_atanpi, PureLibm.cr_atanpi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(_atanpi, PureLibm.cr_atanpi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_atanpi.fast,cr_atanpi"
