# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_asinh(::$T)" begin
        # IEC 60559
        # asinh(±0) returns ±0
        @test PureLibm.cr_asinh(T(0.0)) == T(0.0)
        @test PureLibm.cr_asinh(T(-0.0)) == T(-0.0)
        # asinh(±∞) returns ±∞
        @test PureLibm.cr_asinh(T(Inf)) == T(Inf)

        # sanity check
        @test isnan(PureLibm.cr_asinh(T(NaN)))
    end

    @testset "cr_asinh(random)" begin
        test_x = T[
            eps(T(0.0)),
            # [0, 1e-4]
            rand_float(T(0.0), T(1e-4), 8)...,
            # [1e-4, 0.25]
            rand_float(T(1e-4), T(0.25), 16)...,
            # [0.25, 1e6]
            rand_float(T(0.25), T(1e6), 16)...,

            # branch coverage
            # ((ru & UInt64(0xfffffff)) == 0)
            2.9018954f7,
            6.723824f7,
            1.1760178f8,
            4.8311844f9,
            6.391892f22,
            1.9926346f23,
            2.749153f28,
            9.862078f34,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_asinh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_asinh(x) ≈ asinh(x)
            # Test against MPFR
            @test PureLibm.cr_asinh(x) === T(asinh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_asinh.fast" in CheckExhaustive
    @testset "cr_asinh-exhaustive.fast" begin
        test_float_range(asinh, PureLibm.cr_asinh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(asinh, PureLibm.cr_asinh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_asinh" in CheckExhaustive
    @testset "cr_asinh-exhaustive" begin
        test_float_range(asinh, PureLibm.cr_asinh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(asinh, PureLibm.cr_asinh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_asinh.fast,cr_asinh"
