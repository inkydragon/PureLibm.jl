# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atan(::$T)" begin
        float_all = Data.Floats{T}()
        # atan Domain
        @testset "atan(x) in [-π/2, π/2], for |x| <= 1" begin
            f_domain = filter(x -> abs(x) <= 1, float_all)
            @check atan_domain(f = f_domain) = -π/2 <= PureLibm.cr_atan(f) <= π/2
        end

        # IEC 60559
        @test isnan(PureLibm.cr_atan(T(NaN)))
        # atan(±0) returns ±0
        @test PureLibm.cr_atan(T(0.0)) == T(0.0)
        @test PureLibm.cr_atan(T(-0.0)) == T(-0.0)
        # atan(±∞) returns ±π/2
        @test PureLibm.cr_atan(T(Inf)) == T(pi)/2
        @test PureLibm.cr_atan(T(-Inf)) == -T(pi)/2

        # sanity check
        @test PureLibm.cr_atan(T(1)) == T(pi)/4

        # Coverage
        if Float32 == T
            # if @unlikely(e < (127 - 25))  # |x| < 2.9802322f-8 (0x1p-25)
            @test PureLibm.cr_atan(T(0x1p-26)) == T(1.4901161f-8)
            @test PureLibm.cr_atan(T(0x1p-32)) == T(2.3283064f-10)
            # if @unlikely(e < (127 - 13))  # |x| < 0.00012207031f0 (0x1p-13)
            @test PureLibm.cr_atan(T(0x1p-14)) == T(6.1035156f-5)
            @test PureLibm.cr_atan(T(0x1p-25)) == T(2.9802322f-8)
            # if !gt
            @test PureLibm.cr_atan(T(0.000122703f0)) == T(0.000122703f0)
            @test PureLibm.cr_atan(T(0.50116825f0)) == T(0.4645818f0)
        end
    end
end

const ATANF_INF_LIMIT = nextfloat(Float32(0x1.e00a3p+25))
pos_range = (lo=+Float32(0.0), hi=+ATANF_INF_LIMIT)
neg_range = (lo=-Float32(0.0), hi=-ATANF_INF_LIMIT)
if "cr_atan.fast" in CheckExhaustive
    @testset "cr_atan-exhaustive.fast" begin
        test_float_range(atan, PureLibm.cr_atan, pos_range)
        test_float_range(atan, PureLibm.cr_atan, neg_range)
    end
end
if "cr_atan" in CheckExhaustive
    @testset "cr_atan-exhaustive" begin
        test_float_range(atan, PureLibm.cr_atan, pos_range, bigfloat=true)
        test_float_range(atan, PureLibm.cr_atan, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_atan.fast,cr_atan"
