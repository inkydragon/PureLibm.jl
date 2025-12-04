# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_erf($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_erf(T(NaN)))
        # erf(±0) returns ±0
        @test PureLibm.cr_erf(T(0)) == T(0)
        @test PureLibm.cr_erf(-T(0)) == -T(0)
        # erf(±∞) returns ±1
        @test PureLibm.cr_erf(T(Inf)) == T(1)
        @test PureLibm.cr_erf(-T(Inf)) == -T(1)
    end

    @testset "cr_erf(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(0.5), 16)...,
            rand_float(T(0.5), T(4.0), 16)...,
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
        @testset "cr_erf($(repr(x)))" for x in test_x
            res = PureLibm.cr_erf(x)
            # Test against system libm
            @test res ≈ SpecialFunctions.erf(x)
            # Test against MPFR
            @test res === T(SpecialFunctions.erf(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(4.0))
neg_range = (lo=Float32(-0.0), hi=Float32(-4.0))
if "cr_erf.fast" in CheckExhaustive
    @testset "cr_erf-exhaustive.fast" begin
        test_float_range(SpecialFunctions.erf, PureLibm.cr_erf, pos_range)
        test_float_range(SpecialFunctions.erf, PureLibm.cr_erf, neg_range)
    end
end
if "cr_erf" in CheckExhaustive
    @testset "cr_erf-exhaustive" begin
        test_float_range(SpecialFunctions.erf, PureLibm.cr_erf, pos_range, bigfloat=true)
        test_float_range(SpecialFunctions.erf, PureLibm.cr_erf, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_erf.fast,cr_erf"
