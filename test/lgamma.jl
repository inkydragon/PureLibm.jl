# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions

for T in (Float32, )
    @testset "cr_lgamma($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_lgamma(T(NaN)))
        # # — lgamma(1) returns +0
        # @test PureLibm.cr_lgamma(T(1)) == T(0.0)
        # # — lgamma(2) returns +0
        # @test PureLibm.cr_lgamma(T(2)) == T(0.0)
        # # — lgamma(x) returns +∞ and raises the "divide-by-zero" floating-point exception
        # #   for x a negative integer or zero.
        # @test PureLibm.cr_lgamma(T(0.0)) == T(Inf)
        # @test PureLibm.cr_lgamma(-T(1)) == T(Inf)
        # @test PureLibm.cr_lgamma(-T(2)) == T(Inf)
        # @test PureLibm.cr_lgamma(-T(100)) == T(Inf)
        # # — lgamma(−∞) returns +∞
        # @test PureLibm.cr_lgamma(T(-Inf)) == T(Inf)
        # # — lgamma(+∞) returns +∞
        # @test PureLibm.cr_lgamma(T(Inf)) == T(Inf)
    end
end
