# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_tan(::$T)" begin
        # IEC 60559
        # tan(±0) returns ±0
        @test PureLibm.cr_tan(T(0.0)) == T(0.0)
        @test PureLibm.cr_tan(T(-0.0)) == T(-0.0)
        # tan(±∞) returns NaN
        @test isnan(PureLibm.cr_tan(T(Inf)))
        @test isnan(PureLibm.cr_tan(T(-Inf)))

        # sanity check
        @test isnan(PureLibm.cr_tan(T(NaN)))
        @test PureLibm.cr_tan(T(-pi)) == T(0)
        @test PureLibm.cr_tan(T(-pi/4)) == T(-1)
        @test PureLibm.cr_tan(T(pi/4)) == T(1)
        @test PureLibm.cr_tan(T(pi)) == T(0)
    end
end
