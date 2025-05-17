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
            # Note: atan(6e15) == atan(Inf)
            rand_float(T(0.0), T(6e15), 64)...,

            # Branch Coverage
            # abs(x) >= Float32(0x1.45f306p+124)
            rand_float(T(0x1.45f306p+124), T(prevfloat(Float32(Inf))), 4)...,
            # !(abs(x) >= Float32(0x1.45f306p+124))
            # |x| >= 2^25 && |x| < 0x1.45f306p+124
            rand_float(T(0x1p25), T(0x1.45f306p+124), 4)...,
            # (e < (127 - 13)) && !(e < (127 - 25))
            # 2^-25 <= |x| < 2^-13
            rand_float(T(0x1p-25), T(0x1p-13), 4)...,
            # hard to round cases
            0x1.44cfbap+0,
            0x1.d26a62p-1,
            0x1p+0,
            # !(e > (127 + 24)) && !(e < (127 - 13))
            # 2^-13 <= |x| < 2^25
            rand_float(T(0x1p-13), T(0x1p25), 4)...,
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
