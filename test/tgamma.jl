# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions

@testset "tgamma" begin
    @testset "$T" for T in [Float32, ]
        # IEC 60559
        @test PureLibm.tgamma(T(Inf)) == T(Inf)
        # fp-invalid
        @test isnan(PureLibm.tgamma(T(-Inf)))
        @test isnan(PureLibm.tgamma(T(-1.0)))
        # fp-divide-by-zero
        @test PureLibm.tgamma(T(+0.0)) == T(+Inf)
        @test PureLibm.tgamma(T(-0.0)) == T(-Inf)
        @test isnan(PureLibm.tgamma(T(NaN)))

        # sanity check
        @test PureLibm.tgamma.(T.(1:5)) == T[1, 1, 2, 6, 24]
        @test PureLibm.tgamma(T(36)) == T(Inf)

        # compare test
        for x in 1:36
            @test PureLibm.tgamma(T(x)) ≈ SpecialFunctions.gamma(T(x))
        end
        
    end
end
