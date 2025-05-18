# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_cbrt($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_cbrt(T(NaN)))
        # cbrt(±0) returns ±0
        @test PureLibm.cr_cbrt(T(0.0)) == T(0.0)
        @test PureLibm.cr_cbrt(T(-0.0)) == T(-0.0)
        # cbrt(±∞) returns ±∞
        @test PureLibm.cr_cbrt(T(Inf)) == T(Inf)
        @test PureLibm.cr_cbrt(T(-Inf)) == T(-Inf)

        # sanity check
        for n in rand(1:1000, 16)
            @test PureLibm.cr_cbrt(T(n^3)) == T(n)
            @test PureLibm.cr_cbrt(-T(n^3)) == -T(n)
        end
    end

    @testset "cr_cbrt(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(prevfloat(Float32(Inf))), 64)...,

            # branch Coverage
            # (ub == lb)
            # ::Float32
            1.1775089f38,
            1.3836971f14,
            0.021486675f0,
            0.00019319354f0,
            0.00049376907f0,
            1.8966324f-5,
            5.3827968f-8,
            3.639484f-26,
            4.544312f-28,
            1.1460103f-34,
            rand_float(T(0.0), T(1.0), 32)...,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_cbrt($x)" for x in test_x
            res = PureLibm.cr_cbrt(x)
            # Test against system libm
            @test res ≈ cbrt(x)
            # Test against MPFR
            @test res === T(cbrt(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_cbrt.fast" in CheckExhaustive
    @testset "cr_cbrt-exhaustive.fast" begin
        test_float_range(cbrt, PureLibm.cr_cbrt, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(cbrt, PureLibm.cr_cbrt, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_cbrt" in CheckExhaustive
    @testset "cr_cbrt-exhaustive" begin
        test_float_range(cbrt, PureLibm.cr_cbrt, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(cbrt, PureLibm.cr_cbrt, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cbrt.fast,cr_cbrt"
