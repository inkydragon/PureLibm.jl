# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_acos(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_acos(T(1)) == T(0)
        @test isnan(PureLibm.cr_acos(T(2)))
        @test isnan(PureLibm.cr_acos(T(-2)))
        @test isnan(PureLibm.cr_acos(T(Inf)))
        @test isnan(PureLibm.cr_acos(T(-Inf)))
        @test isnan(PureLibm.cr_acos(T(NaN)))

        # sanity check
        @test PureLibm.cr_acos(T(-1)) ≈ pi
        @test PureLibm.cr_acos(T(0)) * 2 ≈ pi
        @test PureLibm.cr_acos(T(0.5)) * 3 ≈ pi
    end

    @testset "cr_acos(random)" begin
        test_x = T[
            eps(T(0.0)),
            (0.0:0.05:1.0)...,
            rand(0.0:eps(T):1.0, 10)...,
            # Branch cov
            1.5893255f-8, 0.00024868647f0,
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

if "cr_acos.fast" in CheckExhaustive
    @testset "cr_acos-exhaustive.fast" begin
        test_float_range(acos, PureLibm.cr_acos, lo=Float32(0.0), hi=Float32(1.0))
        test_float_range(acos, PureLibm.cr_acos, lo=Float32(-0.0), hi=Float32(-1.0))
    end
end
if "cr_acos" in CheckExhaustive
    @testset "cr_acos-exhaustive" begin
        test_float_range(acos, PureLibm.cr_acos, lo=Float32(0.0), hi=Float32(1.0), bigfloat=true)
        test_float_range(acos, PureLibm.cr_acos, lo=Float32(-0.0), hi=Float32(-1.0), bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_acos.fast,cr_acos"
