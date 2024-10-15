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

if "tgammaf.fast" in CheckExhaustive
    # 4294967296 cases  42.0s
@testset "tgammaf-exhaustive.fast" begin
    xlo = typemin(UInt32)
    xhi = typemax(UInt32)
    # xlo = reinterpret(UInt32, Float32(0.38))
    # xhi = reinterpret(UInt32, Float32(3.0))
    for xu in xlo:xhi
        x = reinterpret(Float32, xu)
        if x < 0 && (isinteger(x) || isinf(x))
            continue  # Skip DomainError
        end
        y = PureLibm.tgamma(x)
        z = SpecialFunctions.gamma(x)

        if isnan(z) && isnan(y)
            continue
        elseif isinf(z) && isinf(y)
            continue
        elseif z ≈ y
            continue
        else
            println("[xu = $xu ($x)]:  y=$y; z=$z")
        end
    end
    println("test $(length(xlo:xhi)) cases")
end
end # CheckExhaustive

if "tgammaf" in CheckExhaustive
# 4294967296 cases  37.1s
@testset "tgammaf-exhaustive" begin
    xlo = typemin(UInt32)
    xhi = typemax(UInt32)
    # xlo = reinterpret(UInt32, Float32(0.38))
    # xhi = reinterpret(UInt32, Float32(3.0))
    for xu in xlo:xhi
        x = reinterpret(Float32, xu)
        if x < 0 && (isinteger(x) || isinf(x))
            continue  # Skip DomainError
        end
        y = PureLibm.tgamma(x)
        z = Float32(SpecialFunctions.gamma(Float32(x)))

        if y === z
            continue
        else
            println("[xu = $xu ($x)]:  y=$y; z=$z")
        end
    end
    println("test $(length(xlo:xhi)) cases")
end
end # CheckExhaustive
