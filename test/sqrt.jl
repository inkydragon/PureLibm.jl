# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_sqrt($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_sqrt(T(NaN)))
        # sqrt(±0) returns ±0
        @test PureLibm.cr_sqrt(T(0.0)) == T(0.0)
        @test PureLibm.cr_sqrt(T(-0.0)) == -T(0.0)
        # sqrt(+∞) returns +∞
        @test PureLibm.cr_sqrt(T(Inf)) == T(Inf)
        # sqrt(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0
        # @test isnan(PureLibm.cr_sqrt(T(-1.0)))
        # @test isnan(PureLibm.cr_sqrt(T(-Inf)))
    end
end
