# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tanpi(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=false)
        # tanpi Domain
        @testset "tanpi(x) in [-∞, ∞], for finite x" begin
            @check tanpi_domain(f = float_gen) = !isnan(PureLibm.cr_tanpi(f))
        end

        # IEC 60559
        # tanpi(±0) returns ±0
        @test PureLibm.cr_tanpi(T(0.0)) == T(0.0)
        @test PureLibm.cr_tanpi(T(-0.0)) == T(-0.0)
        for n in rand(1:10^6, 64)
            odd = 2n - 1
            even = 2n
            # tanpi(n) returns +0, for positive even and negative odd integers n
            @test PureLibm.cr_tanpi(T(even)) == T(0.0)
            @test PureLibm.cr_tanpi(T(-odd)) == T(0.0)
            # tanpi(n) returns −0, for positive odd and negative even integers n
            @test PureLibm.cr_tanpi(T(odd)) == T(-0.0)
            @test PureLibm.cr_tanpi(T(-even)) == T(-0.0)

            # tanpi(n + 1/2) returns +∞ and raises
            #   the "divide-by-zero" floating-point exception,
            #   for even integers n
            @test PureLibm.cr_tanpi(T(even + 0.5)) == T(Inf)
            @test PureLibm.cr_tanpi(T(-even + 0.5)) == T(Inf)
            # tanpi(n + 1/2) returns −∞ and raises
            #   the "divide-by-zero" floating-point exception,
            #   for odd integers n
            @test PureLibm.cr_tanpi(T(odd + 0.5)) == T(-Inf)
            @test PureLibm.cr_tanpi(T(-odd + 0.5)) == T(-Inf)
        end
        @testset "tanpi(x) = +0, for +even and -odd integers x" begin
            int_gen = Data.Integers{Int64}()
            pos_even_gen = filter(x -> x > 0 && iseven(x), int_gen)
            neg_odd_gen = filter(x -> x < 0 && isodd(x), int_gen)
            @check tanpi_domain(f = pos_even_gen) = PureLibm.cr_tanpi(T(f)) == T(0)
            @check tanpi_domain(f = neg_odd_gen) = PureLibm.cr_tanpi(T(f)) == T(0)
        end
        @testset "tanpi(x) = -0, for -even and +odd integers x" begin
            int_gen = Data.Integers{Int64}()
            neg_even_gen = filter(x -> x < 0 && iseven(x), int_gen)
            pos_odd_gen = filter(x -> x > 0 && isodd(x), int_gen)
            @check tanpi_domain(f = neg_even_gen) = PureLibm.cr_tanpi(T(f)) == -T(0)
            @check tanpi_domain(f = pos_odd_gen) = PureLibm.cr_tanpi(T(f)) == -T(0)
        end
        @testset "tanpi(x+1/2) = +Inf, for even integer x" begin
            int_gen = Data.Integers{Int64}()
            even_int_gen = filter(x -> iseven(x), int_gen)
            f_domain = map(x -> x + T(1)/2, even_int_gen)
            f_domain = filter(x -> eps(x) <= T(1)/2, f_domain)
            @check tanpi_domain(f = f_domain) = PureLibm.cr_tanpi(f) == T(Inf)
        end
        @testset "tanpi(x+1/2) = -Inf, for odd integer x" begin
            int_gen = Data.Integers{Int64}()
            odd_int_gen = filter(x -> isodd(x), int_gen)
            f_domain = map(x -> x + T(1)/2, odd_int_gen)
            f_domain = filter(x -> eps(x) <= T(1)/2, f_domain)
            @check tanpi_domain(f = f_domain) = PureLibm.cr_tanpi(f) == -T(Inf)
        end
        # tanpi(±∞) returns a NaN and raises the "invalid" floating-point exception
        @test isnan(PureLibm.cr_tanpi(T(Inf)))
        @test isnan(PureLibm.cr_tanpi(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_tanpi(T(NaN)))
        @test PureLibm.cr_tanpi(-T(1)) == T(0)
        @test PureLibm.cr_tanpi(-T(1)/4) == -T(1)
        @test PureLibm.cr_tanpi(T(1)/4) == T(1)
        @test PureLibm.cr_tanpi(T(1)) == -T(0)

        # Coverage test
        @testset "cr_tanpi(random)" begin
            test_x = T[
                eps(T(0.0)),

                # branch coverage
                # (e > (150 << 23)) && !(e == (UInt32(0xff) << 23))
                #   |x| > 2^23 and (not NaN/Inf)
                rand_float(Float32(0x1p+28), prevfloat(T(Inf)), 8)...,
                2^24,
                # a == 0x3e933802
                0x1.267004p-2,
                # a == 0x38f26685
                0x1.e4cd0ap-14,
            ]
            test_x = [test_x..., -test_x...]
            @testset "cr_tanpi($x)" for x in test_x
                # Test against system libm
                @test PureLibm.cr_tanpi(x) ≈ tanpi(x)
                # Test against MPFR
                @test PureLibm.cr_tanpi(x) === T(tanpi(BigFloat(x)))
            end
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(Inf)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-Inf)))
if "cr_tanpi.fast" in CheckExhaustive
    @testset "cr_tanpi-exhaustive.fast" begin
        test_float_range(tanpi, PureLibm.cr_tanpi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(tanpi, PureLibm.cr_tanpi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_tanpi" in CheckExhaustive
    @testset "cr_tanpi-exhaustive" begin
        test_float_range(tanpi, PureLibm.cr_tanpi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(tanpi, PureLibm.cr_tanpi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tanpi.fast,cr_tanpi"
