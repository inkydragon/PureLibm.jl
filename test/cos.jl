# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_cos(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # cos Domain
        @testset "cos(x) in [-1, 1], for finite x" begin
            @check cos_domain(f = float_gen) = -1 <= PureLibm.cr_cos(f) <= 1
        end
        @testset "cos(x) >= 0, for |x| <= π/2" begin
            f_domain = filter(x -> abs(x) <= π/2, float_gen)
            @check cos_domain(f = f_domain) = PureLibm.cr_cos(f) >= 0
        end
        @testset "cos(x) <= 0, for x in [π/2, 3π/2]" begin
            f_domain = filter(x -> π/2 <= x <= 3π/2, float_gen)
            @check cos_domain(f = f_domain) = PureLibm.cr_cos(f) <= 0
        end

        # IEC 60559
        # cos(±0) returns 1
        @test PureLibm.cr_cos(T(0)) == T(1)
        @test PureLibm.cr_cos(-T(0)) == T(1)
        # cos(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_cos(T(Inf)))
        @test isnan(PureLibm.cr_cos(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_cos(T(NaN)))
        @test PureLibm.cr_cos(T(pi)/4) == sqrt(T(2))/2
        @test PureLibm.cr_cos(T(pi)/2) == T(-4.371139f-8)
        @test PureLibm.cr_cos(T(pi)*3/4) == -sqrt(T(2))/2
        @test PureLibm.cr_cos(T(pi)) == T(-1)
    end

    # Coverage test
    @test _cosf_database(0f0, Float64(pi)) == Float32(pi)
    @testset "cr_cos(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            # -pi~pi
            # range(Float32(0.0), Float32(pi), length=10)...,
            # range(-Float32(0.0), -Float32(pi), length=10)...,
            rand_float(Float32(0.0), Float32(pi), 10)...,
            rand_float(-Float32(0.0), -Float32(pi), 10)...,

            ## Branch coverage
            # cr_cosf: `return -Float32(0x1p-1) * x * x + 1.0f0`
            #   (ax < 0x73000000) and !(ax < 0x66000000)
            #   [0x66000000, 0x73000000)
            rand_float(0x66000000>>1, 0x73000000>>1, 2)...,
            # cr_cosf: `z, ia = rltl(z0)`
            #   !(ax > 0x99000000 || ax < 0x73000000) and !(ax < 0x82a41896)
            #   [0x82a41896, 0x99000000]
            rand_float(0x82a41896>>1, 0x99000000>>1, 2)...,
            # _cosf_big: `return r`
            #   (ax > 0x99000000 || ax < 0x73000000) and !(ax < 0x73000000)
            #       and !(nan or +-inf) and !(tail < 12)
            #   [0x73000000, 0xff000000)
            rand_float(0x73000000>>1, 0xff000000>>1, 8)...,

            # Special cases: _cosf_database
            4.712389f0,
            2.8616508f15,
            2.3127222f16,
            1.1004678f19,
            1.7269983f20,
        ]
        @testset "cr_cos($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cos(x) ≈ cos(x)
            # Test against MPFR
            @test PureLibm.cr_cos(x) === T(cos(BigFloat(x)))
        end
    end
end

if "cr_cos.fast" in CheckExhaustive
    @testset "cr_cos-exhaustive.fast" begin
        test_float_range(cos, PureLibm.cr_cos, F32_POS_FINITE_RANGE)
        test_float_range(cos, PureLibm.cr_cos, F32_NEG_FINITE_RANGE)
    end
end
if "cr_cos" in CheckExhaustive
    @testset "cr_cos-exhaustive" begin
        test_float_range(cos, PureLibm.cr_cos, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(cos, PureLibm.cr_cos, F32_NEG_FINITE_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cos.fast,cr_cos"
