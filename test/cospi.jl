# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32]
    @testset "cr_cospi(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # cospi Domain
        @testset "cospi(x) in [-1, 1], for finite x" begin
            @check cospi_domain(f = float_gen) = -1 <= PureLibm.cr_cospi(f) <= 1
        end

        # IEC 60559
        # cospi(±0) returns 1
        @test PureLibm.cr_cospi(T(0.0)) == T(1.0)
        @test PureLibm.cr_cospi(T(-0.0)) == T(1.0)
        # cospi(n + 1/2) returns +0, for integers n
        for n in rand(1:10^6, 8)
            @test PureLibm.cr_cospi(n + T(0.5)) == T(0.0)
            @test PureLibm.cr_cospi(-n + T(0.5)) == T(0.0)
        end
        @testset "cospi(x+1/2) = 0, for integer x" begin
            int_gen = Data.Integers{Int64}()
            f_domain = map(x -> x + T(1)/2, int_gen)
            f_domain = filter(x -> eps(x) <= T(1)/2, f_domain)
            @check cospi_domain(f = f_domain) = PureLibm.cr_cospi(f) == T(0)
        end
        # cospi(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_cospi(T(Inf)))
        @test isnan(PureLibm.cr_cospi(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_cospi(T(NaN)))
        @test PureLibm.cr_cospi(T(1)/4) == sqrt(T(2))/2
        @test PureLibm.cr_cospi(T(1)/2) == T(0)
        @test PureLibm.cr_cospi(T(3)/4) == -sqrt(T(2))/2
        @test PureLibm.cr_cospi(T(1)) == T(-1)
    end

    # Coverage test
    @testset "cr_cospi(rand($T))" begin
        test_x = T[
            eps(T(0.0)),
            
            # branch coverage
            # ax >= UInt32(0x19f030)
            rand_float(T(0x1.9f03p-129), T(2^-15), 2)...,
            # (p > 63)
            #   e > 175
            0x1p+49,  # 176
            0x1p+53,  # 180
            # 112 <= e <= 143
            2.0^-15,
            2.0^16,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_cospi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_cospi(x) ≈ cospi(x)
            # Test against MPFR
            @test PureLibm.cr_cospi(x) === T(cospi(BigFloat(x)))
        end
    end
end

if "cr_cospi.fast" in CheckExhaustive
    @testset "cr_cospi-exhaustive.fast" begin
        test_float_range(cospi, PureLibm.cr_cospi, F32_POS_FINITE_RANGE)
        test_float_range(cospi, PureLibm.cr_cospi, F32_NEG_FINITE_RANGE)
    end
end
if "cr_cospi" in CheckExhaustive
    @testset "cr_cospi-exhaustive" begin
        test_float_range(cospi, PureLibm.cr_cospi, F32_POS_FINITE_RANGE, bigfloat=true)
        test_float_range(cospi, PureLibm.cr_cospi, F32_NEG_FINITE_RANGE, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_cospi.fast,cr_cospi"
