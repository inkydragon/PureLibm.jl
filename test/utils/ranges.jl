# SPDX-License-Identifier: MIT OR Apache-2.0

"""
Generate random float numbers using `rand(UInt)`.

# Arguments
- `lo::Unsigned`: lower bound
- `hi::Unsigned`: upper bound
- `n::Int`: number of random values

# Returns
- `Vector{T}`: Generator for random float values in the range `[lo, hi]`
"""
function rand_float(xu_lo::T, xu_hi::T, n::Int) where {T<:Unsigned}
    FloatType = Base.floattype(T)
    xu_range = xu_lo:xu_hi
    xu_rand = rand(xu_range, n)
    f_rand = Iterators.map(xu->reinterpret(FloatType, xu), xu_rand)
    f_rand
end

"""
Generate random float numbers using `rand(UInt)`.

# Arguments
- `lo::AbstractFloat`: lower bound
- `hi::AbstractFloat`: upper bound
- `n::Int`: number of random values

# Returns
- `Vector{T}`: Generator for random float values in the range `[lo, hi]`
"""
function rand_float(lo::T, hi::T, n::Int) where {T<:AbstractFloat}
    UIntBaseType = Base.uinttype(T)
    xu_lo = reinterpret(UIntBaseType, lo)
    xu_hi = reinterpret(UIntBaseType, hi)
    rand_float(xu_lo, xu_hi, n)
end

function __main_test_loop(xs, ref_fun, impl_func)
    for x in xs
        y = impl_func(x)
        z = ref_fun(x)
        if isapprox(z, y; nans=true)
            continue
        else
            xu = reinterpret(Base.uinttype(typeof(x)), x)
            @printf("[xu = 0x%x (%e)]:  y=%e; z=%e\n", xu, x, y, z)
        end
    end
end

"""
Test with float range
"""
function test_float_range(ref, impl; lo::T, hi::T, bigfloat=false) where T
    UIntBaseType = Base.uinttype(T)
    xu_lo = reinterpret(UIntBaseType, lo)
    xu_hi = reinterpret(UIntBaseType, hi)
    @assert(xu_lo <= xu_hi,
        "xu_lo=$(repr(xu_lo)) ($(repr(lo))) <= xu_hi=$(repr(xu_hi)) ($(repr(hi)))")

    xu_range = xu_lo:xu_hi
    x_range = Iterators.map(xu->reinterpret(T, xu), xu_range)

    libmname = "libm"
    ref_fun = ref
    if bigfloat
        libmname = "mpfr"
        ref_fun = x -> T(ref(BigFloat(x)))
    end

    @info "testing `$impl` against `$libmname.$ref` in $(repr(lo)):$(repr(hi)) ($xu_range)"
    __main_test_loop(x_range, ref_fun, impl)
    @info "tested $(length(xu_range)) cases"
end

test_float_range(ref, impl, test_range::@NamedTuple{lo::T, hi::T}; bigfloat=false) where T =
    test_float_range(ref, impl; lo=test_range.lo, hi=test_range.hi, bigfloat=bigfloat)
