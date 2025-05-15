# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atanh($T)" begin
        # IEC 60559
        # atanh(±0) returns ±0.
        @test PureLibm.cr_atanh(T(0.0)) == T(0.0)
        @test PureLibm.cr_atanh(T(-0.0)) == T(-0.0)
        # atanh(±1) returns ±∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_atanh(T(1.0)) == T(Inf)
        @test PureLibm.cr_atanh(T(-1.0)) == T(-Inf)
        # atanh(x) returns a NaN and raises the "invalid" floating-point exception for |x| > 1.
        # @test isnan(PureLibm.cr_atanh(T(1.1)))
        # @test isnan(PureLibm.cr_atanh(T(-1.1)))
    
        # sanity check
        @test isnan(PureLibm.cr_atanh(T(NaN)))
    end

    @testset "cr_atanh(random)" begin
        test_x = T[
            eps(T(0.0)),
            # [0, 1]
            rand_float(T(0), T(1.0), 16)...,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_atanh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_atanh(x) ≈ atanh(x)
            # Test against MPFR
            @test PureLibm.cr_atanh(x) === T(atanh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(1.0)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-1.0)))
if "cr_atanh.fast" in CheckExhaustive
    @testset "cr_atanh-exhaustive.fast" begin
        test_float_range(atanh, PureLibm.cr_atanh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(atanh, PureLibm.cr_atanh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_atanh" in CheckExhaustive
    @testset "cr_atanh-exhaustive" begin
        test_float_range(atanh, PureLibm.cr_atanh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(atanh, PureLibm.cr_atanh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_atanh.fast,cr_atanh"
