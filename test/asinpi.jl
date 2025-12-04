# SPDX-License-Identifier: MIT OR Apache-2.0

# ref
_asinpi(x::T) where {T<:AbstractFloat} = T(asin(x) / pi)

for T in [Float32, ]
    @testset "cr_asinpi(::$T)" begin
        float_all = Data.Floats{T}()
        # asinpi Domain
        @testset "asinpi(x) in [-1/2, 1/2], for |x| <= 1" begin
            f_domain = filter(x -> abs(x) <= 1, float_all)
            @check asinpi_domain(f = f_domain) = -T(1) / 2 <= PureLibm.cr_asinpi(f) <= T(1) / 2
        end

        # IEC 60559
        @test isnan(PureLibm.cr_asinpi(T(NaN)))
        # asinpi(±0) returns ±0.
        @test PureLibm.cr_asinpi(T(0.0)) == T(0.0)
        @test PureLibm.cr_asinpi(-T(0.0)) == -T(0.0)
        # asinpi(x) returns a NaN and raises the "invalid" floating-point exception
        #   for |x| > 1.
        @test isnan(PureLibm.cr_asinpi(nextfloat(T(1))))
        @test isnan(PureLibm.cr_asinpi(prevfloat(T(-1))))
        @test isnan(PureLibm.cr_asinpi(T(2)))
        @test isnan(PureLibm.cr_asinpi(T(-2)))
        @test isnan(PureLibm.cr_asinpi(T(Inf)))
        @test isnan(PureLibm.cr_asinpi(T(-Inf)))
        @testset "asinpi(x) = NaN, for |x| > 1" begin
            f_gt1 = filter(x -> abs(x) > 1, float_all)
            @check asinpi_nan(f = f_gt1) = isnan(PureLibm.cr_asinpi(f))
        end
    
        # sanity check
        @test PureLibm.cr_asinpi(-T(1.0)) == -T(1) / 2
        @test PureLibm.cr_asinpi(-T(0.5)) == -T(1) / 6
        @test PureLibm.cr_asinpi(-T(0.0)) == -T(0.0)
        @test PureLibm.cr_asinpi(T(0.0)) == T(0.0)
        @test PureLibm.cr_asinpi(T(0.5)) == T(1) / 6
        @test PureLibm.cr_asinpi(T(1.0)) == T(1) / 2
    end

    @testset "cr_asinpi(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 32)...,

            # Branch coverage
            # i == 0
            0x1p-5,  # (s = 24, i = 0)
            # !(i == 0)
            #   s in (19, 32)
            0x1p-4,  # (s = 23, i = 1)
            0x1p-3,  # (s = 22, i = 2)
            0x1p-2,  # (s = 21, i = 4)
            0x1p-1,  # (s = 20, i = 8)
            # s = 20, i in [9, 15]
            0x1.2p-1,
            0x1.4p-1,
            0x1.6p-1,
            0x1.8p-1,
            0x1.ap-1,
            0x1.cp-1,
            0x1.ep-1,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_asinpi($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_asinpi(x) ≈ _asinpi(x)
            # Test against MPFR
            @test PureLibm.cr_asinpi(x) === T(_asinpi(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(1.0)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-1.0)))
if "cr_asinpi.fast" in CheckExhaustive
    @testset "cr_asinpi-exhaustive.fast" begin
        test_float_range(_asinpi, PureLibm.cr_asinpi, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(_asinpi, PureLibm.cr_asinpi, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_asinpi" in CheckExhaustive
    @testset "cr_asinpi-exhaustive" begin
        test_float_range(_asinpi, PureLibm.cr_asinpi, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(_asinpi, PureLibm.cr_asinpi, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_asinpi.fast,cr_asinpi"
