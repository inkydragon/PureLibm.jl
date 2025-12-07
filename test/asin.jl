# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_asin(::$T)" begin
        float_all = Data.Floats{T}()
        # asin Domain
        @testset "asin(x) in [-π/2, π/2], for |x| <= 1" begin
            f_domain = filter(x -> abs(x) <= 1, float_all)
            @check asin_domain(f = f_domain) = -π/2 <= PureLibm.cr_asin(f) <= π/2
        end

        # IEC 60559, oneAPI
        # asin(±0) returns ±0
        @test PureLibm.cr_asin(T(0.0)) == T(0.0)
        @test PureLibm.cr_asin(T(-0.0)) == -T(0.0)
        # asin(±1) = ±π/2
        @test PureLibm.cr_asin(T(1.0)) == T(pi) / 2
        @test PureLibm.cr_asin(-T(1.0)) == -T(pi) / 2
        # asin(x) returns a NaN and raises the "invalid" floating-point exception
        #   for |x| > 1
        @test isnan(PureLibm.cr_asin(nextfloat(T(1))))
        @test isnan(PureLibm.cr_asin(prevfloat(T(-1))))
        @test isnan(PureLibm.cr_asin(T(2)))
        @test isnan(PureLibm.cr_asin(T(-2)))
        @test isnan(PureLibm.cr_asin(T(Inf)))
        @test isnan(PureLibm.cr_asin(T(-Inf)))
        @testset "asin(x) = NaN, for |x| > 1" begin
            f_gt1 = filter(x -> abs(x) > 1, float_all)
            @check asin_nan(f = f_gt1) = isnan(PureLibm.cr_asin(f))
        end

        # sanity check
        @test isnan(PureLibm.cr_asin(T(NaN)))
        # Special Values
        @test PureLibm.cr_asin(T(-1.0)) == T(-pi) / 2
        @test PureLibm.cr_asin(T(-0.5)) == T(-pi) / 6
        @test PureLibm.cr_asin(T(0.0)) == T(0.0)
        @test PureLibm.cr_asin(T(0.5)) == T(pi) / 6
        @test PureLibm.cr_asin(T(1.0)) == T(pi) / 2
    end

    @testset "cr_asin(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 16)...,

            ## Branch cov
            # ax == 0x7e55688a
            0.6668132f0,
            # ax == 0x7e107434
            0.53213656f0,
            # |x| < 0.5
            rand_float(T(0.0), T(0.5), 8)...,
            # |x| < 0.5 and !(ub == lb)
            0.00044382224f0,
            0.49999875f0,
            # 0.5 <= |x| < 1.0
            rand_float(T(0.5), T(1.0), 8)...,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_asin($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_asin(x) ≈ asin(x)
            # Test against MPFR
            @test PureLibm.cr_asin(x) === T(asin(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(1.0))
neg_range = (lo=Float32(-0.0), hi=Float32(-1.0))
if "cr_asin.fast" in CheckExhaustive
    @testset "cr_asin-exhaustive.fast" begin
        test_float_range(asin, PureLibm.cr_asin, pos_range)
        test_float_range(asin, PureLibm.cr_asin, neg_range)
    end
end
if "cr_asin" in CheckExhaustive
    @testset "cr_asin-exhaustive" begin
        test_float_range(asin, PureLibm.cr_asin, pos_range, bigfloat=true)
        test_float_range(asin, PureLibm.cr_asin, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_asin.fast,cr_asin"
