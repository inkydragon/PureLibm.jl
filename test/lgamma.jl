# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions

for T in (Float32, )
    @testset "cr_lgamma($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_lgamma(T(NaN)))
        # — lgamma(1) returns +0
        @test PureLibm.cr_lgamma(T(1)) == T(0.0)
        # — lgamma(2) returns +0
        @test PureLibm.cr_lgamma(T(2)) == T(0.0)
        # — lgamma(x) returns +∞ and raises the "divide-by-zero" floating-point exception
        #   for x a negative integer or zero.
        @test PureLibm.cr_lgamma(T(0.0)) == T(Inf)
        @test PureLibm.cr_lgamma(-T(0.0)) == T(Inf)
        @test PureLibm.cr_lgamma(-T(1)) == T(Inf)
        @test PureLibm.cr_lgamma(-T(2)) == T(Inf)
        @test PureLibm.cr_lgamma(-T(100)) == T(Inf)
        # — lgamma(−∞) returns +∞
        @test PureLibm.cr_lgamma(T(-Inf)) == T(Inf)
        # — lgamma(+∞) returns +∞
        @test PureLibm.cr_lgamma(T(Inf)) == T(Inf)

        # ---- sanity check
        # lgamma(x+1) = lgamma(x) + log(x)
        # lgamma(0.5) = log(π^0.5)
        @test PureLibm.cr_lgamma(T(0.5)) ≈ T(0.5 * log(π))
        # lgamma(3/2) = log(1/2 * √π)
        @test PureLibm.cr_lgamma(T(1.5)) ≈ T(0.5 * log(π) - log(2))
        # lgamma(5/2) = log(3/4 * √π)
        @test PureLibm.cr_lgamma(T(2.5)) ≈ T(0.5 * log(π) + log(3) - 2 * log(2))
        # lgamma(7/2) = log(15/8 * √π)
        @test PureLibm.cr_lgamma(T(3.5)) ≈ T(0.5 * log(π) + log(15) - 3 * log(2))
        # lgamma(-1/2) = log(|-2 * √π|)
        @test PureLibm.cr_lgamma(T(-0.5)) ≈ T(log(2) + 0.5 * log(π))
        # lgamma(-3/2) = log(|4/3 * √π|)
        @test PureLibm.cr_lgamma(T(-1.5)) ≈ T(log(4/3) + 0.5 * log(π))
        # lgamma(-5/2) = log(|-8/15 * √π|)
        @test PureLibm.cr_lgamma(T(-2.5)) ≈ T(log(8/15) + 0.5 * log(π))
        #= Γ(z)Γ(1-z) = π / sin(πz) =#
        # Γ(1/3)Γ(2/3) = 2π/√3
        @test PureLibm.cr_lgamma(T(1//3)) + PureLibm.cr_lgamma(T(2//3)) ≈ T(log(2π) - log(sqrt(3)))
        # Γ(1/4)Γ(3/4) = π√2
        @test PureLibm.cr_lgamma(T(1//4)) + PureLibm.cr_lgamma(T(3//4)) ≈ T(log(π) + log(sqrt(2)))

        # --- compare test
        for x in 1:100
            @test PureLibm.cr_lgamma(T(x)) ≈ SpecialFunctions.lgamma(T(x))
        end
    end
end
