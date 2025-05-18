# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_log10($T)" begin
        # IEC 60559

        # sanity check

    end

    @testset "cr_log10(rand($T))" begin
        test_x = T[
            eps(T(0.0)),

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
