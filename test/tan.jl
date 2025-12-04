# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tan(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # tan Domain
        @testset "tan(x) in [-∞, ∞], for finite x" begin
            @check tan_domain(f = float_gen) = !isnan(PureLibm.cr_tan(f))
        end
        @testset "tan(x) >= 0, for x in [0, π/2]" begin
            f_domain = filter(x -> 0 <= x <= π/2, float_gen)
            @check tan_domain(f = f_domain) = PureLibm.cr_tan(f) >= 0
        end
        @testset "tan(x) <= 0, for x in [-π/2, 0]" begin
            f_domain = filter(x -> -π/2 <= x <= 0, float_gen)
            @check tan_domain(f = f_domain) = PureLibm.cr_tan(f) <= 0
        end

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

if "cr_tan.fast" in CheckExhaustive
    @testset "cr_tan-exhaustive.fast" begin
        test_float_range(tan, PureLibm.cr_tan, F32_POS_FINITE_RANGE)
        test_float_range(tan, PureLibm.cr_tan, F32_NEG_FINITE_RANGE)
    end
end
if "cr_tan" in CheckExhaustive
    @testset "cr_tan-exhaustive" begin
        test_float_range(tan, PureLibm.cr_tan, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(tan, PureLibm.cr_tan, F32_NEG_FINITE_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tan.fast,cr_tan"
