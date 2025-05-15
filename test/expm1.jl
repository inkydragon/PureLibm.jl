# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_expm1(::$T)" begin
        # IEC 60559
        # expm1(±0) returns ±0.
        @test PureLibm.cr_expm1(zero(T)) == zero(T)
        @test PureLibm.cr_expm1(-zero(T)) == -zero(T)
        # expm1(−∞) returns −1.
        @test PureLibm.cr_expm1(-T(Inf)) == -one(T)
        # expm1(+∞) returns +∞.
        @test PureLibm.cr_expm1(T(Inf)) == T(Inf)

        # sanity check
        @test isnan(PureLibm.cr_expm1(T(NaN)))
        @test PureLibm.cr_expm1(T(1)) ≈ T(ℯ - 1.0)
        # overflow
        @test PureLibm.cr_expm1(89f0) == Inf32      # expm1(89f0) == Inf32
        @test PureLibm.cr_expm1(T(710)) == T(Inf)   # expm1(710) == Inf64
        # underflow
        @test PureLibm.cr_expm1(-17.4f0) == -one(T)
    end

    @testset "cr_expm1(random)" begin
        test_x = T[
            eps(T(0.0)),
            # rand_float(T(0.0), T(1.0), 16)...,

            ## Branch cov
            # (ax < 0x676a09e8)
            #   |x| < 0x1.6a09e8p-24
            rand_float(T(0), T(0x1.6a09e8p-24), 4)...,
            # (ax < 0x7c400000) && !(ax < 0x676a09e8)
            #   0x1.6a09e8p-24 <= |x| < 0.15625
            0x1.6a09e8p-24,
            rand_float(T(0x1.6a09e8p-24), T(0.15625), 4)...,
            # (ax >= 0x8562e430) && (not NaN)
            # && (ux >> 31 != 0) && !(ax == (UInt32(0xff) << 24))
            #   |x| > 88.72 && x < 0 && x!=Inf
            rand_float(-T(88.72), -T(710), 4)...,
            # (ub != lb) && !(ux > 0xc18aa123)
            # XXX: empty
            # (ub != lb) && !(ux > 0xc18aa123)
            0.30389398,
            0.30733502,
            3.722294,
            3.8374038,
        ]
        @testset "cr_expm1($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_expm1(x) ≈ expm1(x)
            # Test against MPFR
            @test PureLibm.cr_expm1(x) === T(expm1(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(Inf))
neg_range = (lo=Float32(-0.0), hi=Float32(-Inf))
if "cr_expm1.fast" in CheckExhaustive
    @testset "cr_expm1-exhaustive.fast" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_expm1" in CheckExhaustive
    @testset "cr_expm1-exhaustive" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_expm1.fast,cr_expm1"
