# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_exp10m1($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_exp10m1(T(NaN)))
        # # exp10m1(±0) returns ±0
        # @test PureLibm.cr_exp10m1(T(0.0)) == T(0)
        # @test PureLibm.cr_exp10m1(-T(0.0)) == -T(0)
        # # exp10m1(−∞) returns -1
        # @test PureLibm.cr_exp10m1(-T(Inf)) == -T(1)
        # # exp10m1(+∞) returns +∞
        # @test PureLibm.cr_exp10m1(T(Inf)) == T(Inf)
    end
end
