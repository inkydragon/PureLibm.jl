# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions

for T in (Float32, )
    @testset "cr_erfc($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_erfc(T(NaN)))
        @test isnan(PureLibm.cr_erfc(-T(NaN)))
        # erfc(−∞) returns 2
        @test PureLibm.cr_erfc(T(-Inf)) == T(2)
        # erfc(+∞) returns +0
        @test PureLibm.cr_erfc(T(Inf)) == T(0)

        # sanitize check
        @test PureLibm.cr_erfc(T(0.0)) == T(1.0)
        @test PureLibm.cr_erfc(-T(0.0)) == T(1.0)
    end

    @testset "cr_erfc(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(Inf), 128)...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if tu > 0xc07547ca
                #   and not:  if tu >= 0xff800000
                # x > -3.8325067f0
                -3.8325067f0,
                rand_float(-3.8325067f0, T(-Inf), 16)...,
                # if tu == 0xb76c9f62
                # x = -0x1.d93ec4p-17
                T(-0x1.d93ec4p-17),

                # now -0x1.ea8f94p+1 <= x <= 0x1.41bbf8p+3, with |x| > 0x1.7p-4
                -0x1.ea8f94p+1, 0x1.41bbf8p+3, 0x1.7p-4,
                rand_float(0.08984375f0, 10.054195f0, 16)...,
                rand_float(-0.08984375f0, -3.8325067f0, 16)...,
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
