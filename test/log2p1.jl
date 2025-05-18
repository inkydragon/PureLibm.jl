# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log2p1($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_log2p1(T(NaN)))
        # log2p1(±0) returns ±0
        @test PureLibm.cr_log2p1(T(0)) == T(0)
        @test PureLibm.cr_log2p1(-T(0)) == -T(0)
        # log2p1(−1) returns −∞ and raises the "divide-by-zero" floating-point exception
        @test PureLibm.cr_log2p1(-T(1)) == -T(Inf)
        # log2p1(x) returns a NaN and raises the "invalid" floating-point exception for x < −1
        @test isnan(PureLibm.cr_log2p1(-T(1.1)))
        @test isnan(PureLibm.cr_log2p1(-T(2.0)))
        @test isnan(PureLibm.cr_log2p1(-T(100)))
        # log2p1(+∞) returns +∞
        @test PureLibm.cr_log2p1(T(Inf)) == T(Inf)

    end

    @testset "cr_log2p1(rand($T))" begin
        test_x = T[
            eps(T(0.0)),

        ]
        @testset "cr_log2p1($x)" for x in test_x
            res = PureLibm.cr_log2p1(x)
            # Test against system libm
            @test res ≈ log2p1(x)
            # Test against MPFR
            @test res === T(log2p1(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(+1.0), hi=Float32(Inf))
if "cr_log2p1.fast" in CheckExhaustive
    @testset "cr_log2p1-exhaustive.fast" begin
        test_float_range(log2p1, PureLibm.cr_log2p1, lo=pos_range.lo, hi=pos_range.hi)
    end
end
if "cr_log2p1" in CheckExhaustive
    @testset "cr_log2p1-exhaustive" begin
        test_float_range(log2p1, PureLibm.cr_log2p1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_log2p1.fast,cr_log2p1"
