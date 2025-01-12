# SPDX-License-Identifier: MIT OR Apache-2.0
import SpecialFunctions
using Random

@testset "cr_tgamma" begin
    @testset "$T" for T in [Float32, ]
        # IEC 60559
        @test PureLibm.cr_tgamma(T(Inf)) == T(Inf)
        # fp-invalid
        @test isnan(PureLibm.cr_tgamma(T(-Inf)))
        @test isnan(PureLibm.cr_tgamma(T(-1.0)))
        # fp-divide-by-zero
        @test PureLibm.cr_tgamma(T(+0.0)) == T(+Inf)
        @test PureLibm.cr_tgamma(T(-0.0)) == T(-Inf)
        @test isnan(PureLibm.cr_tgamma(T(NaN)))

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
