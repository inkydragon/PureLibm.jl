# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atanh($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
        # atanh Domain
        @testset "atanh(x) >= 0, for 0 <= x <= 1" begin
            f_domain = filter(x -> 0 <= x <= 1, float_gen)
            @check atanh_domain(f = f_domain) = PureLibm.cr_atanh(f) >= 0
        end
        @testset "atanh(x) <= 0, for -1 <= x <= 0" begin
            f_domain = filter(x -> -1 <= x <= 0, float_gen)
            @check atanh_domain(f = f_domain) = PureLibm.cr_atanh(f) <= 0
        end

        # IEC 60559
        @test isnan(PureLibm.cr_atanh(T(NaN)))
        # atanh(±0) returns ±0.
        @test PureLibm.cr_atanh(T(0.0)) == T(0.0)
        @test PureLibm.cr_atanh(T(-0.0)) == T(-0.0)
        # atanh(±1) returns ±∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_atanh(T(1.0)) == T(Inf)
        @test PureLibm.cr_atanh(T(-1.0)) == T(-Inf)
        # atanh(x) returns a NaN and raises the "invalid" floating-point exception
        #   for |x| > 1.
        @test isnan(PureLibm.cr_atanh(T(1.1)))
        @test isnan(PureLibm.cr_atanh(T(-1.1)))
        for x in rand_float(nextfloat(T(1.0)), prevfloat(T(Inf)), 16)
            @test isnan(PureLibm.cr_atanh(x))
            @test isnan(PureLibm.cr_atanh(-x))
        end
        @test isnan(PureLibm.cr_atanh(T(Inf)))
        @test isnan(PureLibm.cr_atanh(T(-Inf)))
        @testset "atanh(x) = NaN, for |x| > 1" begin
            f_domain = filter(x -> abs(x) > 1, float_gen)
            @check atanh_domain(f = f_domain) = isnan(PureLibm.cr_atanh(f))
        end

        # sanity check
    end

    @testset "cr_atanh(random)" begin
        test_x = T[
            eps(T(0.0)),
            # [0, 1]
            rand_float(T(0), T(1.0), 16)...,

            # branch coverage
            # (ax < 0x7a300000 || ax >= 0x7f000000) && !(ax < 0x73713744)
            #   0x73713744 <= ax < 0x7a300000
            #   0x1.713744p-12 <= |x| < 0x1.3p-5
            rand_float(T(0x1.713744p-12), T(0x1.3p-5), 8)...,
            # !( (ax < 0x7a300000 || ax >= 0x7f000000) )
            #   |x| >= 0x1.3p-5
            rand_float(T(0x1.3p-5), T(1.0), 8)...,
            # !(ub != lb)
            0.03923541,
            0.03928607,
            0.096043855,
            0.09605185,
            0.5866644,
            0.5999646,
            0.9553215,
            0.99992925,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_atanh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_atanh(x) ≈ atanh(x)
            # Test against MPFR
            @test PureLibm.cr_atanh(x) === T(atanh(BigFloat(x)))
        end
    end
end

pos_range = (lo=+Float32(0.0), hi=+Float32(1.0))
neg_range = (lo=-Float32(0.0), hi=-Float32(1.0))
if "cr_atanh.fast" in CheckExhaustive
    @testset "cr_atanh-exhaustive.fast" begin
        test_float_range(atanh, PureLibm.cr_atanh, pos_range)
        test_float_range(atanh, PureLibm.cr_atanh, neg_range)
    end
end
if "cr_atanh" in CheckExhaustive
    @testset "cr_atanh-exhaustive" begin
        test_float_range(atanh, PureLibm.cr_atanh, pos_range, bigfloat=true)
        test_float_range(atanh, PureLibm.cr_atanh, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_atanh.fast,cr_atanh"
