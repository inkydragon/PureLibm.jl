# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sin(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # sin Domain
        @testset "sin(x) in [-1, 1], for finite x" begin
            @check sin_domain(f = float_gen) = -1 <= PureLibm.cr_sin(f) <= 1
        end
        @testset "sin(x) >= 0, for x in [0, π]" begin
            f_domain = filter(x -> 0 <= x <= π, float_gen)
            @check sin_domain(f = f_domain) = PureLibm.cr_sin(f) >= 0
        end
        @testset "sin(x) <= 0, for x in [π, 2π]" begin
            f_domain = filter(x -> π <= x <= 2π, float_gen)
            @check sin_domain(f = f_domain) = PureLibm.cr_sin(f) <= 0
        end

        # IEC 60559
        # sin(±0) returns ±0
        @test PureLibm.cr_sin(T(0)) == T(0)
        @test PureLibm.cr_sin(-T(0)) == -T(0)
        # sin(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_sin(T(Inf)))
        @test isnan(PureLibm.cr_sin(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_sin(T(NaN)))
        @test PureLibm.cr_sin(T(pi)/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sin(T(pi)/2) == T(1.0f0)
        @test PureLibm.cr_sin(T(pi)*3/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sin(T(pi)) == T(-8.742278f-8)
    end

    # Coverage test
    @testset "cr_sin(random)" begin
        test_x = T[
            eps(T(0.0)),
            # -pi~pi
            rand_float(Float32(0.0), Float32(pi), 10)...,
            rand_float(-Float32(0.0), -Float32(pi), 10)...,
            # 0x66000000 < ax < 0x73000000
            rand_float(0x33000000, 0x39800000, 4)...,
            # big input > 0x1p+26
            #   _sinf_rbig:  if s < 64
            rand_float(Float32(0x1p+26), Float32(0x1p+84), 4)...,
            #   _sinf_rbig:  elseif s == 64
            rand_float(Float32(0x1p+84), Float32(0x1p+85), 4)...,
            #   _sinf_rbig:  s > 64
            rand_float(Float32(0x1p+85), typemax(Float32), 4)...,
            # Special cases: _sinf_database
            9830.398f0,
            0.72992426f0,
            1.3086903f0,
            9.424778f0,
        ]
        @testset "cr_sin($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_sin(x) ≈ sin(x)
            # Test against MPFR
            @test PureLibm.cr_sin(x) === T(sin(BigFloat(x)))
        end
    end
end

if "cr_sin.fast" in CheckExhaustive
    @testset "cr_sin-exhaustive.fast" begin
        test_float_range(sin, PureLibm.cr_sin, F32_POS_FINITE_RANGE)
        test_float_range(sin, PureLibm.cr_sin, F32_NEG_FINITE_RANGE)
    end
end
if "cr_sin" in CheckExhaustive
    @testset "cr_sin-exhaustive" begin
        test_float_range(sin, PureLibm.cr_sin, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(sin, PureLibm.cr_sin, F32_NEG_FINITE_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sin.fast,cr_sin"
