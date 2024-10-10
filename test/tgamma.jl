# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions
using Random

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
        # special value
        @test PureLibm.tgamma(T(1/2)) ≈ T(sqrt(π))
        @test PureLibm.tgamma(T(-1/2)) ≈ T(-2sqrt(π))

        # --- compare test
        for x in 1:36
            @test PureLibm.tgamma(T(x)) ≈ SpecialFunctions.gamma(T(x))
        end
        # tgammaf(0.38)=1.937f  ~  tgammaf(3.0)=2.0f
        xlo = reinterpret(UInt32, Float32(0.38))
        xhi = reinterpret(UInt32, Float32(3.0))
        for xu in rand(xlo:xhi, 10^3)
            x = reinterpret(Float32, xu)
            @test PureLibm.tgamma(x) ≈ SpecialFunctions.gamma(x)
        end
    end
end

if "tgammaf" in CheckExhaustive
# 1108344833  3m00.4s
@testset "tgamma-exhaustive[0f, 36f]" begin
    
    xlo = reinterpret(UInt32, Float32(0.0))
    xhi = reinterpret(UInt32, Float32(36.0))
    for xu in xlo:xhi
        x = reinterpret(Float32, xu)
        @test PureLibm.tgamma(x) ≈ SpecialFunctions.gamma(x)
    end
end
end # CheckExhaustive
