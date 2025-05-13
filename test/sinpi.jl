# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sinpi(::$T)" begin
        # IEC 60559
        # sin(±0) returns ±0
        @test PureLibm.cr_sinpi(T(0)) == T(0)
        @test PureLibm.cr_sinpi(-T(0)) == -T(0)
        # sin(±∞) returns a NaN
        @test isnan(PureLibm.cr_sinpi(T(Inf)))
        @test isnan(PureLibm.cr_sinpi(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_sinpi(T(NaN)))
        @test PureLibm.cr_sinpi(T(1)/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sinpi(T(1)/2) == T(1)
        @test PureLibm.cr_sinpi(T(1)*3/4) ≈ sqrt(T(2))/2
        @test PureLibm.cr_sinpi(T(1)) == T(0)
    end

    # # Coverage test
    # @testset "cr_sinpi(random)" begin
    #     test_x = T[
    #         eps(T(0.0)),
    #         # -pi~pi
    #         rand_float(Float32(0.0), Float32(pi), 10)...,
    #         rand_float(-Float32(0.0), -Float32(pi), 10)...,
    #         # 0x66000000 < ax < 0x73000000
    #         rand_float(0x33000000, 0x39800000, 4)...,
    #         # big input > 0x1p+26
    #         #   _sinf_rbig:  if s < 64
    #         rand_float(Float32(0x1p+26), Float32(0x1p+84), 4)...,
    #         #   _sinf_rbig:  elseif s == 64
    #         rand_float(Float32(0x1p+84), Float32(0x1p+85), 4)...,
    #         #   _sinf_rbig:  s > 64
    #         rand_float(Float32(0x1p+85), typemax(Float32), 4)...,
    #         # Special cases: _sinf_database
    #         9830.398f0,
    #         0.72992426f0,
    #         1.3086903f0,
    #         9.424778f0,
    #     ]
    #     @testset "cr_sinpi($x)" for x in test_x
    #         # Test against system libm
    #         @test PureLibm.cr_sinpi(x) ≈ sin(x)
    #         # Test against MPFR
    #         @test PureLibm.cr_sinpi(x) === T(sin(BigFloat(x)))
    #     end
    # end
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
