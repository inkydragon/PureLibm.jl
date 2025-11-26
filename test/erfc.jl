# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions

for T in (Float32, )
    @testset "cr_erfc($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_erfc(T(NaN)))
        # erfc(−∞) returns 2
        @test PureLibm.cr_erfc(T(-Inf)) == T(2)
        # erfc(+∞) returns +0
        @test PureLibm.cr_erfc(T(Inf)) == T(0)
    end

    @testset "cr_erfc(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(Inf), 64)...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if @unlikely(uax > 0x407ad444)
                #   |x| > 3.9192057f0 (0x1.f5a888p+1)
                3.9192057f0, nextfloat(3.9192057f0),
                rand_float(T(3.9), T(Inf), 32)...,
                # if @unlikely(uax < 0x3ee0_0000)
                #   |x| < 0.4375f0 (0x1.cp-2)
                prevfloat(0.4375f0),
                0.4375f0,
                nextfloat(0.4375f0),
                rand_float(T(0.0), 0.4375f0, 32)...,
            ])
        end
        @testset "cr_erfc($(repr(x)))" for x in test_x
            res = PureLibm.cr_erfc(x)
            # Test against system libm
            @test res ≈ SpecialFunctions.erfc(x)
            # Test against MPFR
            @test res === T(SpecialFunctions.erfc(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(Inf))
neg_range = (lo=Float32(-0.0), hi=Float32(-Inf))
if "cr_erfc.fast" in CheckExhaustive
    @testset "cr_erfc-exhaustive.fast" begin
        test_float_range(SpecialFunctions.erfc, PureLibm.cr_erfc, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(SpecialFunctions.erfc, PureLibm.cr_erfc, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_erfc" in CheckExhaustive
    @testset "cr_erfc-exhaustive" begin
        test_float_range(SpecialFunctions.erfc, PureLibm.cr_erfc, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(SpecialFunctions.erfc, PureLibm.cr_erfc, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_erfc.fast,cr_erfc"
