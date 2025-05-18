# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions
using Random

@testset "cr_tgamma" begin
    @testset "$T" for T in [Float32, ]
        # IEC 60559
        @test isnan(PureLibm.cr_tgamma(T(NaN)))
        # tgamma(±0) returns ±∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_tgamma(T(+0.0)) == T(+Inf)
        @test PureLibm.cr_tgamma(T(-0.0)) == T(-Inf)
        # tgamma(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x a negative integer.
        @test isnan(PureLibm.cr_tgamma(T(-1.0)))
        # tgamma(−∞) returns a NaN and raises the "invalid" floating-point exception.
        @test isnan(PureLibm.cr_tgamma(T(-Inf)))
        # tgamma(+∞) returns +∞
        @test PureLibm.cr_tgamma(T(Inf)) == T(Inf)

        # sanity check
        @test PureLibm.cr_tgamma.(T.(1:5)) == T[1, 1, 2, 6, 24]
        @test PureLibm.cr_tgamma(T(36)) == T(Inf)
        # special value
        @test PureLibm.cr_tgamma(T(1/2)) ≈ T(sqrt(π))
        @test PureLibm.cr_tgamma(T(-1/2)) ≈ T(-2sqrt(π))

        # --- compare test
        for x in 1:36
            @test PureLibm.cr_tgamma(T(x)) ≈ SpecialFunctions.gamma(T(x))
        end
        # tgammaf(0.38)=1.937f  ~  tgammaf(3.0)=2.0f
        xlo = reinterpret(UInt32, Float32(0.38))
        xhi = reinterpret(UInt32, Float32(3.0))
        for xu in rand(xlo:xhi, 10^3)
            x = reinterpret(Float32, xu)
            @test PureLibm.cr_tgamma(x) ≈ SpecialFunctions.gamma(x)
        end
        
        # Coverage
        if Float32 == T
            # Upper if tu == tb[i][1]
            @test PureLibm.cr_tgamma(T(6.1763377f-15)) == T(1.6190824f14)
            @test PureLibm.cr_tgamma(T(-2.8004695f-6)) == T(-357083.56f0)
            # Lower if tu == tb[j][1]
            @test PureLibm.cr_tgamma(T(0.015363082f0)) == T(64.52887f0)
            @test PureLibm.cr_tgamma(T(-3.6221597f0)) == T(0.24537095f0)
            # if @unlikely(x < -42.0)  # negative non-integer
            @test PureLibm.cr_tgamma(T(-42.1)) == T(0)
            @test PureLibm.cr_tgamma(T(-43.1)) == -T(0)
        end
    end
end


function filter_DomainError(x)
    bad = x < 0 && (isinteger(x) || isinf(x))
    !bad
end

function test_float_range_filter(ref, impl; lo::T, hi::T, bigfloat=false) where T
    UIntBaseType = Base.uinttype(T)
    xu_lo = reinterpret(UIntBaseType, lo)
    xu_hi = reinterpret(UIntBaseType, hi)
    xu_range = xu_lo:xu_hi
    x_range = Iterators.map(xu->reinterpret(T, xu), xu_range)
    x_range = Iterators.filter(filter_DomainError, x_range)

    libmname = "libm"
    ref_fun = ref
    if bigfloat
        libmname = "mpfr"
        ref_fun = x -> T(ref(BigFloat(x)))
    end

    @info "testing `$impl` against `$libmname.$ref` in $lo:$hi ($xu_range)"
    __main_test_loop(x_range, ref_fun, impl)
    @info "tested $(length(xu_range)) cases"
end

if "cr_tgamma.fast" in CheckExhaustive
    @testset "cr_tgamma-exhaustive.fast" begin
        test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, lo=Float32(0.0), hi=Float32(50.0))
        test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, lo=Float32(-0.0), hi=Float32(-50.0))
    end
end
if "cr_tgamma" in CheckExhaustive
    @testset "cr_tgamma-exhaustive" begin
        test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, lo=Float32(0.0), hi=Float32(50.0), bigfloat=true)
        test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, lo=Float32(-0.0), hi=Float32(-50.0), bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tgamma.fast,cr_tgamma"
