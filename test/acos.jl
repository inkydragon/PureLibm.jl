# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_acos(::$T)" begin
        float_all = Data.Floats{T}()
        # acos Domain
        @testset "acos(x) in [0, π], for |x| <= 1" begin
            f_domain = filter(x -> abs(x) <= 1, float_all)
            @check acos_domain(f = f_domain) = 0 <= PureLibm.cr_acos(f) <= π
        end

        # IEC 60559, oneAPI
        # acos(-1) = +π
        @test PureLibm.cr_acos(-T(1)) == T(pi)
        # acos(±0) = +π/2
        @test PureLibm.cr_acos(T(0)) == T(pi) / 2
        @test PureLibm.cr_acos(-T(0)) == T(pi) / 2
        # acos(1) returns +0
        @test PureLibm.cr_acos(T(1)) == T(0)
        # acos(x) returns a NaN and raises the "invalid" floating-point exception
        #   for |x| > 1
        @test isnan(PureLibm.cr_acos(nextfloat(T(1))))
        @test isnan(PureLibm.cr_acos(prevfloat(T(-1))))
        @test isnan(PureLibm.cr_acos(T(2)))
        @test isnan(PureLibm.cr_acos(T(-2)))
        @test isnan(PureLibm.cr_acos(T(Inf)))
        @test isnan(PureLibm.cr_acos(T(-Inf)))
        @testset "acos(x) = NaN, for |x| > 1" begin
            f_gt1 = filter(x -> abs(x) > 1, float_all)
            @check acos_nan(f = f_gt1) = isnan(PureLibm.cr_acos(f))
        end

        # sanity check
        @test isnan(PureLibm.cr_acos(T(NaN)))
        # Special Values
        @test PureLibm.cr_acos(-T(1)) == T(pi)
        @test PureLibm.cr_acos(-T(0.5)) == T(pi) * 2/3
        @test PureLibm.cr_acos(-T(0)) == T(pi) / 2
        @test PureLibm.cr_acos(T(0)) == T(pi) / 2
        @test PureLibm.cr_acos(T(0.5)) == T(pi) / 3
        @test PureLibm.cr_acos(T(1)) == T(0)
    end

    @testset "cr_acos(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 16)...,

            ## Branch cov
            # tu == 0x328885a3
            1.5893255f-8,
            # tu == 0x39826222
            0.00024868647f0,
            # |x| < 0.5
            rand_float(T(0.0), T(0.5), 8)...,
            1.5700948f-8,
            1.5701799f-8,
            # 0.5 <= |x| < 1.0
            rand_float(T(0.5), T(1.0), 8)...,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_acos($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_acos(x) ≈ acos(x)
            # Test against MPFR
            @test PureLibm.cr_acos(x) === T(acos(BigFloat(x)))
        end
    end
end

pos_range = (lo=Float32(0.0), hi=Float32(1.0))
neg_range = (lo=Float32(-0.0), hi=Float32(-1.0))
if "cr_acos.fast" in CheckExhaustive
    @testset "cr_acos-exhaustive.fast" begin
        test_float_range(acos, PureLibm.cr_acos, pos_range)
        test_float_range(acos, PureLibm.cr_acos, neg_range)
    end
end
if "cr_acos" in CheckExhaustive
    @testset "cr_acos-exhaustive" begin
        test_float_range(acos, PureLibm.cr_acos, pos_range, bigfloat=true)
        test_float_range(acos, PureLibm.cr_acos, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_acos.fast,cr_acos"
