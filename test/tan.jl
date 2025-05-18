# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tan(::$T)" begin
        # IEC 60559
        # tan(±0) returns ±0
        @test PureLibm.cr_tan(T(0.0)) == T(0.0)
        @test PureLibm.cr_tan(T(-0.0)) == T(-0.0)
        # tan(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_tan(T(Inf)))
        @test isnan(PureLibm.cr_tan(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_tan(T(NaN)))
        # @test PureLibm.cr_tan(T(-pi)) == T(0)
        @test PureLibm.cr_tan(T(-pi/4)) == T(-1)
        @test PureLibm.cr_tan(T(pi/4)) == T(1)
        # @test PureLibm.cr_tan(T(pi)) == T(0)
        
        # Coverage test
        @testset "cr_tan(random)" begin
            test_x = T[
                eps(T(0.0)),
                # 0 ~ pi/2
                rand_float(Float32(0.0), Float32(pi/2), 8)...,

                # Branch coverage
                # cr_tanf: `elseif e < 0xff`
                rand_float(Float32(0x1p+28), prevfloat(Float32(0x1p+128)), 8)...,
                # _tanf_rbig: `elseif s == 64`
                # k = 87
                Float32(0x1p+87),

                # Special cases: _tanf_database
                Float32(0x1.143ec4p+0),
                Float32(0x1.ada6aap+27),
                Float32(0x1.af61dap+48),
                Float32(0x1.0088bcp+52),
                Float32(0x1.f90dfcp+72),
                Float32(0x1.cc4e22p+85),
                Float32(0x1.a6ce12p+86),
                Float32(0x1.6a0b76p+102),                
            ]
            test_x = [test_x..., -test_x...]
            @testset "cr_tan($x)" for x in test_x
                # Test against system libm
                @test PureLibm.cr_tan(x) ≈ tan(x)
                # Test against MPFR
                @test PureLibm.cr_tan(x) === T(tan(BigFloat(x)))
            end
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_tan.fast" in CheckExhaustive
    @testset "cr_tan-exhaustive.fast" begin
        test_float_range(tan, PureLibm.cr_tan, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(tan, PureLibm.cr_tan, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_tan" in CheckExhaustive
    @testset "cr_tan-exhaustive" begin
        test_float_range(tan, PureLibm.cr_tan, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(tan, PureLibm.cr_tan, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tan.fast,cr_tan"
