# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tanpi(::$T)" begin
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
