# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log2($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_log2(T(NaN)))
        # log2(±0) returns −∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_log2(T(0.0)) == -T(Inf)
        @test PureLibm.cr_log2(T(-0.0)) == -T(Inf)
        # log2(1) returns +0.
        @test PureLibm.cr_log2(T(1)) == T(0.0)
        # log2(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0.
        @test isnan(PureLibm.cr_log2(T(-0.1)))
        @test isnan(PureLibm.cr_log2(T(-1)))
        @test isnan(PureLibm.cr_log2(T(-Inf)))
        # log2(+∞) returns +∞.
        @test PureLibm.cr_log2(T(Inf)) == T(Inf)

        # sanity check
        @test PureLibm.cr_log2(T(2)) == T(1)
        @test PureLibm.cr_log2(1/T(2)) == T(-1)
    end

    @testset "cr_log2(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
   
        ]
        @testset "cr_log2($x)" for x in test_x
            res = PureLibm.cr_log2(x)
            # Test against system libm
            @test res ≈ log2(x)
            # Test against MPFR
            @test res === T(log2(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(+0.0), hi=Float32(Inf))
if "cr_log2.fast" in CheckExhaustive
    @testset "cr_log2-exhaustive.fast" begin
        test_float_range(log2, PureLibm.cr_log2, lo=pos_range.lo, hi=pos_range.hi)
    end
end
if "cr_log2" in CheckExhaustive
    @testset "cr_log2-exhaustive" begin
        test_float_range(log2, PureLibm.cr_log2, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log2.fast,cr_log2"
