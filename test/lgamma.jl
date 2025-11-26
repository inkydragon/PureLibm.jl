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
    end

    @testset "cr_lgamma(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 16)...,
            rand_float(T(1.0), T(2.0), 64)...,
            rand_float(T(1), T(100), 64)...,
            1:100...,

            ## Branch cov
            # if @unlikely(x >= Float32(0x1.895f1cp+121))
            0x1.895f1cp+121, 5.0f36,
            # if ax > 1198.0f0
            rand_float(1198.0f0, 1.048576f6, 8)...,

            # if x < 0.0f0
            # if @unlikely(tu < 0x40301b93 && tu > 0x402f95c2)
            rand_float(2.7435155f0, 2.751683f0, 8)...,
            # elseif @unlikely(tu > 0x401ceccb && tu < 0x401d95ca)
            rand_float(2.4519527f0, 2.4622674f0, 8)...,
            # elseif @unlikely(tu > 0x40492009 && tu < 0x404940ef)
            rand_float(3.1425803f0, 3.1445882f0, 8)...,

            # if @unlikely(tl <= UInt64(31))
            0x1.ecf3fep-73, 0x1.f8a754p-9,
            0x1.8d16b2p+5, 0x1.87bdfp+115,
            -0x1.25cb66p-123, -0x1.c2f04p-30,
            -0x1.580c1ep+1, -0x1.efc2a2p+14,
        ]
        test_x = [test_x..., -test_x...]
        @testset "cr_lgamma($x)" for x in test_x
            # Test against system libm
            @test PureLibm.cr_lgamma(x) ≈ SpecialFunctions.lgamma(x)
            # Test against MPFR
            @test PureLibm.cr_lgamma(x) === T(SpecialFunctions.lgamma(BigFloat(x)))
        end
    end
end
