# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log10($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_log10(T(NaN)))
        # log10(±0) returns −∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_log10(T(0)) == -T(Inf)
        @test PureLibm.cr_log10(-T(0)) == -T(Inf)
        # log10(1) returns +0.
        @test PureLibm.cr_log10(T(1)) == T(0)
        # log10(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0.
        @test isnan(PureLibm.cr_log10(-T(0.1)))
        @test isnan(PureLibm.cr_log10(-T(1)))
        @test isnan(PureLibm.cr_log10(-T(10)))
        @test isnan(PureLibm.cr_log10(-T(Inf)))
        # log10(+∞) returns +∞.
        @test PureLibm.cr_log10(T(Inf)) == T(Inf)

        # sanity check
        # Note: prevfloat(typemax(Float32)) == 3.4028235f38
        @test PureLibm.cr_log10(T(1e38)) == T(38)
        @test PureLibm.cr_log10(T(100)) == T(2)
        @test PureLibm.cr_log10(T(10)) == T(1)
        @test PureLibm.cr_log10(T(1)) == T(0)
        @test PureLibm.cr_log10(T(0.1)) == -T(1)
        @test PureLibm.cr_log10(T(0.01)) == -T(2)
        # Note: eps(Float32(0.0)) == 0x1p-149  # 1.401298464324817e-45
        @test PureLibm.cr_log10(T(0x1p-149)) == -T(44.8534693539332)
    end

    @testset "cr_log10(rand($T))" begin
        test_x = T[
            eps(T(0.0)),

            # Branch coverage
            # (ub != lb)
            1.1208f-35,
            1.0031539f-34,
            0.00038358592f0,
            1.00264f0,
        ]
        @testset "cr_log10($x)" for x in test_x
            res = PureLibm.cr_log10(x)
            # Test against system libm
            @test res ≈ log10(x)
            # Test against MPFR
            @test res === T(log10(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(+0.0), hi=Float32(Inf))
if "cr_log10.fast" in CheckExhaustive
    @testset "cr_log10-exhaustive.fast" begin
        test_float_range(log10, PureLibm.cr_log10, lo=pos_range.lo, hi=pos_range.hi)
    end
end
if "cr_log10" in CheckExhaustive
    @testset "cr_log10-exhaustive" begin
        test_float_range(log10, PureLibm.cr_log10, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log10.fast,cr_log10"
