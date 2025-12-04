# SPDX-License-Identifier: MIT OR Apache-2.0

function filter_DomainError(x)
    bad = x < 0 && (isinteger(x) || isinf(x))
    !bad
end

for T in (Float32, )
    @testset "cr_tgamma($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_tgamma(T(NaN)))
        # tgamma(±0) returns ±∞ and raises the "divide-by-zero" floating-point exception.
        @test PureLibm.cr_tgamma(T(+0.0)) == T(+Inf)
        @test PureLibm.cr_tgamma(T(-0.0)) == T(-Inf)
        # tgamma(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x a negative integer.
        @test isnan(PureLibm.cr_tgamma(T(-1.0)))
        @testset "tgamma(x) = NaN, for negative integer x" begin
            int_gen = Data.Integers{Int64}()
            f_domain = filter(x -> x < 0, int_gen)
            @check tgamma_domain(f = f_domain) = isnan(PureLibm.cr_tgamma(T(f)))
        end
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

        # Branch cov
        # if @unlikely(x <= Float32(-0x1p+31))
        @test isnan(PureLibm.cr_tgamma(Float32(-0x1p+31)))
    end

    @testset "cr_tgamma(random)" begin
        test_x = T[
            eps(T(0.0)),
            rand_float(T(0.0), T(1.0), 16)...,
            rand_float(T(0.38), T(3.0), 128)...,
            1:36...,
        ]
        if Float32 == T
            # Branch cov
            append!(test_x, T[
                # if @unlikely(x < -42.0)  # negative non-integer
                -42.1f0, -43.1f0,

                # Upper:  if tu == tb[i][1]
                6.1763377f-15, -2.8004695f-6,
                # Lower:  if tu == tb[j][1]
                0.015363082f0, -3.6221597f0,
            ])
        end
        test_x = [test_x..., -test_x...]
        @testset "cr_tgamma($(repr(x)))" for x in Iterators.filter(filter_DomainError, test_x)
            # Test against system libm
            @test PureLibm.cr_tgamma(x) ≈ SpecialFunctions.gamma(x)
            # Test against MPFR
            @test PureLibm.cr_tgamma(x) === T(SpecialFunctions.gamma(BigFloat(x)))
        end
    end
end


function _test_float_range_filter(ref, impl; lo::T, hi::T, bigfloat=false) where T
    UIntBaseType = Base.uinttype(T)
    xu_lo = reinterpret(UIntBaseType, lo)
    xu_hi = reinterpret(UIntBaseType, hi)
    xu_range = xu_lo:xu_hi
    x_range = Iterators.map(xu->reinterpret(T, xu), xu_range)
    x_range = Iterators.filter(filter_DomainError, x_range)  # XXX: filter bad tests

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
_test_float_range_filter(ref, impl, test_range::@NamedTuple{lo::T, hi::T}; bigfloat=false) where T =
    _test_float_range_filter(ref, impl; lo=test_range.lo, hi=test_range.hi, bigfloat=bigfloat)

pos_range = (lo=+Float32(0.0), hi=+Float32(36))       # 35.0401f0
neg_range = (lo=-Float32(0.0), hi=-Float32(42.0))
if "cr_tgamma.fast" in CheckExhaustive
    @testset "cr_tgamma-exhaustive.fast" begin
        _test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, pos_range)
        _test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, neg_range)
    end
end
if "cr_tgamma" in CheckExhaustive
    @testset "cr_tgamma-exhaustive" begin
        _test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, pos_range, bigfloat=true)
        _test_float_range_filter(SpecialFunctions.gamma, PureLibm.cr_tgamma, neg_range, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_tgamma.fast,cr_tgamma"
