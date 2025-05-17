# SPDX-License-Identifier: MIT OR Apache-2.0

# ref
_acospi(x::T) where {T<:AbstractFloat} = T(acos(x) / pi)


for T in [Float32, ]
    @testset "cr_acospi(::$T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_acospi(T(NaN)))
        # acospi(+1) returns +0.
        @test PureLibm.cr_acospi(T(1.0)) == T(0.0)
        # acospi(x) returns a NaN and raises the "invalid" floating-point exception
        #   for |x| > 1.
        @test isnan(PureLibm.cr_acospi(T(2.0)))

        # sanity check

    end

    @testset "cr_acospi(random)" begin
        test_x = T[
            eps(T(0.0)),

            ## Branch cov

        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_acospi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_acospi(x) ≈ _acospi(x)
            # Test against MPFR
            @test PureLibm.cr_acospi(x) === T(_acospi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(1.0)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-1.0)))
if "cr_acospi.fast" in CheckExhaustive
    @testset "cr_acospi-exhaustive.fast" begin
        test_float_range(_acospi, PureLibm.cr_acospi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(_acospi, PureLibm.cr_acospi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_acospi" in CheckExhaustive
    @testset "cr_acospi-exhaustive" begin
        test_float_range(_acospi, PureLibm.cr_acospi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(_acospi, PureLibm.cr_acospi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_acospi.fast,cr_acospi"
