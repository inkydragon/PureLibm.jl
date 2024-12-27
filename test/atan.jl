# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atan(::$T)" begin
        # IEC 60559
        @test PureLibm.cr_atan(T(0.0)) == T(0.0)
        @test PureLibm.cr_atan(T(-0.0)) == T(-0.0)
        @test PureLibm.cr_atan(T(Inf)) ≈ pi/2
        @test PureLibm.cr_atan(T(-Inf)) ≈ -pi/2
        @test isnan(PureLibm.cr_atan(T(NaN)))
    
        # sanity check
        @test PureLibm.cr_atan(T(1)) ≈ pi/4
    end
end

if "cr_atan.fast" in CheckExhaustive
    @testset "cr_atan-exhaustive.fast" begin
        test_float_range(atan, PureLibm.cr_atan, lo=Float32(0.0), hi=Float32(4pi))
        test_float_range(atan, PureLibm.cr_atan, lo=Float32(-0.0), hi=Float32(-4pi))
    end
end
if "cr_atan" in CheckExhaustive
    @testset "cr_atan-exhaustive" begin
        test_float_range(atan, PureLibm.cr_atan, lo=Float32(0.0), hi=Float32(4pi), bigfloat=true)
        test_float_range(atan, PureLibm.cr_atan, lo=Float32(-0.0), hi=Float32(-4pi), bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_atan.fast,cr_atan"
