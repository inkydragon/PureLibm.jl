# SPDX-License-Identifier: MIT OR Apache-2.0

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
    xu_range = xu_lo:xu_hi
    x_range = Iterators.map(xu->reinterpret(T, xu), xu_range)

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
