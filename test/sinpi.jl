# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sinpi(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # sinpi Domain
        @testset "sinpi(x) in [-1, 1], for finite x" begin
            @check sinpi_domain(f = float_gen) = -1 <= PureLibm.cr_sinpi(f) <= 1
        end

        # IEC 60559
        # sinpi(±0) returns ±0
        @test PureLibm.cr_sinpi(T(0)) == T(0)
        @test PureLibm.cr_sinpi(-T(0)) == -T(0)
        # sinpi(±n) returns ±0, for positive integers n.
        for n in 1:10
            @test PureLibm.cr_sinpi(T(n)) == T(0)
            @test PureLibm.cr_sinpi(-T(n)) == -T(0)
        end
        @testset "sinpi(x+1/2) = 0, for integer x" begin
            int_gen = Data.Integers{Int64}()
            pos_int_gen = filter(x -> x > 0, int_gen)
            neg_int_gen = filter(x -> x < 0, int_gen)
            @check sinpi_domain_gt0(f = pos_int_gen) = PureLibm.cr_sinpi(T(f)) == T(0)
            @check sinpi_domain_lt0(f = neg_int_gen) = PureLibm.cr_sinpi(T(f)) == -T(0)
        end
        # sinpi(±∞) returns a NaN
        @test isnan(PureLibm.cr_sinpi(T(Inf)))
        @test isnan(PureLibm.cr_sinpi(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_sinpi(T(NaN)))
        @test PureLibm.cr_sinpi(T(1)/4) == sqrt(T(2))/2
        @test PureLibm.cr_sinpi(T(1)/2) == T(1)
        @test PureLibm.cr_sinpi(T(1)*3/4) == sqrt(T(2))/2
        @test PureLibm.cr_sinpi(T(1)) == T(0)
    end

    # Coverage test
    @testset "cr_sinpi(random)" begin
        test_x = T[
            eps(T(0.0)),
            # -2~2
            rand_float(Float32(0), Float32(2), 10)...,
            rand_float(-Float32(0), -Float32(2), 10)...,
            # s < 0  # |x| >= 0x1p+17
            0x1p+17, 0x1p+22,
            rand_float(Float32(0x1p+17), Float32(0x1p+23), 8)...,
            # s < 0 && s < -6  # |x| >= 0x1p+23
            0x1p+23,
            rand_float(Float32(0x1p+23), prevfloat(Inf32), 8)...,
        ]
        @testset "cr_sinpi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_sinpi(x) ≈ sinpi(x)
            # Test against MPFR
            @test PureLibm.cr_sinpi(x) === T(sinpi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_sinpi.fast" in CheckExhaustive
    @testset "cr_sinpi-exhaustive.fast" begin
        test_float_range(sinpi, PureLibm.cr_sinpi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(sinpi, PureLibm.cr_sinpi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_sinpi" in CheckExhaustive
    @testset "cr_sinpi-exhaustive" begin
        test_float_range(sinpi, PureLibm.cr_sinpi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(sinpi, PureLibm.cr_sinpi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ~
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sinpi.fast,cr_sinpi"
