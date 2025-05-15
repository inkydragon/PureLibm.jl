# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_sinh(::$T)" begin
        # IEC 60559
        # sinh(±0) returns ±0
        @test PureLibm.cr_sinh(T(0.0)) == T(0.0)
        @test PureLibm.cr_sinh(T(-0.0)) == T(-0.0)
        # sinh(±∞) returns ±∞
        @test PureLibm.cr_sinh(T(Inf)) == T(Inf)
        @test PureLibm.cr_sinh(T(-Inf)) == T(-Inf)

        # sanity check
        @test isnan(PureLibm.cr_sinh(T(NaN)))
        # overflow
        @test !isinf(PureLibm.cr_sinh(T(89)))
        @test PureLibm.cr_sinh(Float32(90)) == T(Inf)
        # @test !isinf(PureLibm.cr_sinh(90.0))
        # @test !isinf(PureLibm.cr_sinh(709.0))
        @test PureLibm.cr_sinh(T(710)) == T(Inf)
        # sinh(-x) == -sinh(x)
        for n in 0:90
            @test PureLibm.cr_sinh(-T(n)) == -PureLibm.cr_sinh(T(n))
        end
        # for Float64
        for n in rand(90:710, 16)
            @test PureLibm.cr_sinh(-T(n)) == -PureLibm.cr_sinh(T(n))
        end
    end

    # Coverage test
    @testset "cr_sinh(random)" begin
        test_x = T[
            eps(T(0.0)),
            # [0, 90]
            rand_float(T(0), T(90), 16)...,

            # branch coverage
            # ux == 0x74250bfe
            0.0005589425,
            # (ux <= 0x74250bfe) && !(ux < 0x66000000)
            # [0x1p-24, 0x1.250bfep-11]
            rand_float(T(0x1p-24), T(0x1.250bfep-11), 8)...,
            # (ux < 0x7c000000) && !(ux <= 0x74250bfe)
            # [0x1.250bfep-11, 0.125]
            rand_float(T(0x1.250bfep-11), T(0.125), 8)...,
            # (ub != lb)
            0.2567545,
            0.3000602,
            3.00006,
            3.9815507,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_sinh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_sinh(x) ≈ sinh(x)
            # Test against MPFR
            @test PureLibm.cr_sinh(x) === T(sinh(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=prevfloat(Float32(90)))
neg_range = (lo=Float32(-0.0), hi=nextfloat(Float32(-90)))
if "cr_sinh.fast" in CheckExhaustive
    @testset "cr_sinh-exhaustive.fast" begin
        test_float_range(sinh, PureLibm.cr_sinh, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(sinh, PureLibm.cr_sinh, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_sinh" in CheckExhaustive
    @testset "cr_sinh-exhaustive" begin
        test_float_range(sinh, PureLibm.cr_sinh, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(sinh, PureLibm.cr_sinh, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_sinh.fast,cr_sinh"
