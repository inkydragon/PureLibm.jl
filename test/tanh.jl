# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tanh(::$T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)
        # tanh Domain
        @testset "tanh(x) in [-1, 1], for all x" begin
            @check tanh_domain(f = float_gen) = -1 <= PureLibm.cr_tanh(f) <= 1
        end
        @testset "tanh(x) in [0, 1], for x >= 0" begin
            f_gt0 = filter(x -> x >= 0, float_gen)
            @check tanh_domain(f = f_gt0) = 0 <= PureLibm.cr_tanh(f) <= 1
        end
        @testset "tanh(x) in [-1, 0], for x <= 0" begin
            f_lt0 = filter(x -> x <= 0, float_gen)
            @check tanh_domain(f = f_lt0) = -1 <= PureLibm.cr_tanh(f) <= 0
        end

        # IEC 60559, F.10.2.6
        #   tanh(±0) returns ±0.
        @test PureLibm.cr_tanh(T(+0.0)) ≈ +0.0
        @test PureLibm.cr_tanh(T(-0.0)) ≈ -0.0
        #   tanh(±∞) returns ±1.
        @test PureLibm.cr_tanh(T(+Inf)) === T(+1.0)
        @test PureLibm.cr_tanh(T(-Inf)) === T(-1.0)

        # test NaN
        @test isnan(PureLibm.cr_tanh(T(NaN)))
        @test isnan(PureLibm.cr_tanh(T(-NaN)))
    end

    @testset "cr_tanh(random)" begin
        test_x = T[
            # tanhf32(3pi) == 1
            # tanhf64(7pi) == 1
            (n*pi for n in 1:7)...,
            # [0.0, 7*pi]
            rand(0.0:eps():7pi, 10)...,
            # branch cov
            # 102 <= e < 105
            0x1p-25,
            # e < 102
            0.0,
            0x1p-27,
        ]
        test_x = [test_x..., -test_x...]
        @testset "tanh($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_tanh(x) ≈ tanh(x)
            # Test against MPFR
            @test PureLibm.cr_tanh(x) === T(tanh(BigFloat(x)))
        end
    end
end

const TANHF_INF_LIMIT = Float32(4pi)
pos_range = (lo=+Float32(0.0), hi=+TANHF_INF_LIMIT)
neg_range = (lo=-Float32(0.0), hi=-TANHF_INF_LIMIT)
if "cr_tanh.fast" in CheckExhaustive
    @testset "cr_tanh-exhaustive.fast" begin
        test_float_range(tanh, PureLibm.cr_tanh, pos_range)
        test_float_range(tanh, PureLibm.cr_tanh, neg_range)
    end
end
if "cr_tanh" in CheckExhaustive
    @testset "cr_tanh-exhaustive" begin
        test_float_range(tanh, PureLibm.cr_tanh, pos_range, bigfloat=true)
        test_float_range(tanh, PureLibm.cr_tanh, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tanh.fast,cr_tanh"
