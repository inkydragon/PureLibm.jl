# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/asin/asinf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

const CR_ASINF_B = NTuple{16, Float64}((
    0x1.0000000000005p+0, 0x1.55557aeca105dp-3, 0x1.3314ec3db7d12p-4, 0x1.775738a5a6f92p-5,
    0x1.5d5f7ce1c8538p-8, 0x1.605c6d58740fp-2, -0x1.5728b732d73c6p+1, 0x1.f152170f151ebp+3,
    -0x1.f962ea3ca992ep+5, 0x1.71971e17375ap+7, -0x1.860512b4ba23p+8, 0x1.26a3b8d4bdb14p+9,
    -0x1.36f2ea5698b51p+9, 0x1.b3d722aebfa2ep+8, -0x1.6cf89703b1289p+7, 0x1.1518af6a65e2dp+5
))

const CR_ASINF_C1 = NTuple{12, Float64}((
    0x1.555555555529cp-3, 0x1.333333337e0ddp-4, 0x1.6db6db3b4465ep-5, 0x1.f1c72e13ac306p-6,
    0x1.6e89cebe06bc4p-6, 0x1.1c6dcf5289094p-6, 0x1.c6dbbcc7c6315p-7, 0x1.8f8dc2615e996p-7,
    0x1.a5833b7bf15e8p-8, 0x1.43f44ace1665cp-6, -0x1.0fb17df881c73p-6, 0x1.07520c026b2d6p-5
))

const CR_ASINF_C2 = NTuple{12, Float64}((
    0x1.6a09e667f3bcbp+0, 0x1.e2b7dddff2db9p-4, 0x1.b27247ab42dbcp-6, 0x1.02995cc4e0744p-7,
    0x1.5ffb0276ec8eap-9, 0x1.033885a928decp-10, 0x1.911f2be23f8c7p-12, 0x1.4c3c55d2437fdp-13,
    0x1.af477e1d7b461p-15, 0x1.abd6bdff67dcbp-15, -0x1.1717e86d0fa28p-16, 0x1.6ff526de46023p-16
))


"""
Special cases for `acosf` when `|x| > 1`
"""
function _asinf_as_special(x::Float32)
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if ax > (0x000_00ff << 24)
        # asin(NaN) = NaN
        return x + x
    end

    # asin(+-Inf) = NaN
    # to raise FE_INVALID
    return 0.0f0 / 0.0f0
end

"""
    cr_asin(x::Float32)

Correctly-rounded arc-sine function for `Float32`.

# Examples
```jldoctest
julia> cr_asin(-1.0f0) / pi
-0.5f0

julia> cr_asin(-0.5f0) / pi  # -1/6
-0.16666667f0

julia> cr_asin(-0.0f0) / pi
-0.0f0

julia> cr_asin(0.0f0) / pi
0.0f0

julia> cr_asin(0.5f0) / pi
0.16666667f0

julia> cr_asin(1.0f0) / pi
0.5f0

julia> cr_asin(NaN32)
NaN32

julia> cr_asin(Inf32)
NaN32
```

# Reference
- [src/binary32/asin/asinf.c](https://gitlab.inria.fr/core-math/core-math/-/blob/2c08994e3cd967a63c4c1eed729353a1c3b9c798/src/binary32/asin/asinf.c)
"""
cr_asin(x::Float32) = cr_asinf(x)

function cr_asinf(x::Float32)::Float32
    # pi/2 constant
    pi2 = 0x1.921fb54442d18p+0
    @assert isequal(pi2, pi/2)

    xs = Float64(x)
    r = Float64(0.0)
    tu = reinterpret(UInt32, x)
    ax = tu << UInt32(1)

    if @unlikely(ax > (0x0000_007f << 24))
        # |x| > 1.0
        return _asinf_as_special(x)
    end

    if @likely(ax < 0x7ec29000)
        # |x| < 0.8800049f0
        if @unlikely(ax < UInt32(115 << 24))
            # |x| < 0.00024414062f0 (0x1p-12)
            #= The Taylor expansion of asin(x) at x=0 is x + x^3/6 + o(x^3),
                thus for |x| >= 2^-126 we have no underflow, whatever the
                rounding mode.
                For |x| < 2^-126 and rounding towards zero, we have underflow.
                For x = nextbelow(2^-126) = 0x1.fffffcp-127, asin(x) would round
                upward to 0x1.fffffep-127 with unbounded exponent range, which is not
                representable, thus we have underflow too.
                In summary, we have underflow whenever |x| < 2^-126. 
            =#
            # if x != 0 && abs(x) < Float32(0x1p-126)
            #     nothing  # underflow
            # end
            return fma(x, Float32(0x1p-25), x)
        end

        z = xs
        r = z * poly_x2_c16(z, CR_ASINF_B)

        ub = Float32(r)
        lb = Float32(r - z * 0x1.efa8ebp-31)
        if ub == lb
            return ub
        end
    end

    # Accurate path
    if ax < (0x0000_007e << 24)
        # |x| < 0.5
        z = xs
        z2 = z * z
        c0 = poly12(z2, CR_ASINF_C1)
        r = z + (z * z2) * c0
    else
        # 0.5 <= |x| <= 1.0
        if @unlikely(ax == 0x7e55688a)  # 0.6668132f0
            return copysign(Float32(0x1.75b8a2p-1), x) + copysign(Float32(0x1p-26), x)
        end
        if @unlikely(ax == 0x7e107434)  # 0.53213656f0
            return copysign(Float32(0x1.1f4b64p-1), x) + copysign(Float32(0x1p-26), x)
        end

        bx = abs(xs)
        z = 1.0 - bx
        s = sqrt(z)
        r = pi2 - s * poly12(z, CR_ASINF_C2)
        r = copysign(r, xs)
    end

    return Float32(r)
end
