# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sincos(::$T)" begin
        # IEC 60559
        # sin(±0) returns ±0
        # cos(±0) returns 1
        @test PureLibm.cr_sincos(T(0)) == (T(0), T(1))
        @test PureLibm.cr_sincos(-T(0)) == (-T(0), T(1))
        # sin(±∞) returns a NaN
        # cos(±∞) returns a NaN
        @test all(isnan.(PureLibm.cr_sincos(T(Inf))))
        @test all(isnan.(PureLibm.cr_sincos(T(-Inf))))

        # sanity check
        @test all(isnan.(PureLibm.cr_sincos(T(NaN))))
        s, c = PureLibm.cr_sincos(T(pi)/4)
        @test s ≈ sqrt(T(2))/2
        @test c == sqrt(T(2))/2
        @test PureLibm.cr_sincos(T(pi)/2) == (T(1.0f0), T(-4.371139f-8))
        s, c = PureLibm.cr_sincos(T(pi)*3/4)
        @test s ≈ sqrt(T(2))/2
        @test c == -sqrt(T(2))/2
        @test PureLibm.cr_sincos(T(pi)) == (T(-8.742278f-8), T(-1))
    end

    # Coverage test
    @test PureLibm._sincosf_database(0f0, Float32(pi), exp(0f0)) == (Float32(pi), exp(0f0))
    @testset "cr_sincos(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            # -pi~pi
            range(Float32(0.0), Float32(pi), length=10)...,
            range(-Float32(0.0), -Float32(pi), length=10)...,
            rand_float(Float32(0.0), Float32(pi), 10)...,
            rand_float(-Float32(0.0), -Float32(pi), 10)...,

            ## Branch coverage
            # cr_sincosf: `sout = (-Float32(0x1.555556p-3) * x) * (x * x) + x`
            #   (ax < 0x822d97c8) and (ax < 0x73000000) and !(ax < 0x66000000)
            #   [0x66000000, 0x73000000]
            rand_float(0x66000000>>1, 0x73000000>>1, 2)...,
            # cr_sincosf: `return _sincosf_big(x)`
            #   !(ax < 0x822d97c8) and (ax > 0x99000000) and !(nan or +-inf)
            #   [0x99000000, 0xff000000]
            rand_float(0x99000000>>1, 0xff000000>>1, 4)...,

            # Special cases: _sincosf_database
            9830.398f0,
            0.72992426f0,
            1.3086903f0,
            9.424778f0,
            4.712389f0,
            2.8616508f15,
            2.3127222f16,
            1.1004678f19,
            1.7269983f20,
        ]
        @testset "cr_sincos($x)" for x in test_x
            # Test against system libm
            s, c = PureLibm.cr_sincos(x)
            @test s ≈ sin(x)
            @test c ≈ cos(x)
            # Test against MPFR
            big_x = BigFloat(x)
            @test PureLibm.cr_sincos(x) === (T(sin(big_x)), T(cos(big_x)))
        end
    end
end

if "cr_sincos.fast" in CheckExhaustive
    @testset "cr_sincos-exhaustive.fast" begin
        _cr_sin(x) = PureLibm.cr_sincos(x)[1]
        _cr_cos(x) = PureLibm.cr_sincos(x)[2]
        test_float_range(sin, _cr_sin, F32_POS_FINITE_RANGE)
        test_float_range(sin, _cr_sin, F32_NEG_FINITE_RANGE)
        test_float_range(cos, _cr_cos, F32_POS_FINITE_RANGE)
        test_float_range(cos, _cr_cos, F32_NEG_FINITE_RANGE)
    end
end
if "cr_sincos" in CheckExhaustive
    # TODO: test (sin, cos) in one function
    @testset "cr_sincos-exhaustive" begin
        _cr_sin(x) = PureLibm.cr_sincos(x)[1]
        _cr_cos(x) = PureLibm.cr_sincos(x)[2]
        test_float_range(sin, _cr_sin, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(sin, _cr_sin, F32_NEG_FINITE_RANGE, bigfloat=true)
        test_float_range(cos, _cr_cos, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(cos, _cr_cos, F32_NEG_FINITE_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sincos.fast,cr_sincos"
