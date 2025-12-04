# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan/atanf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

#! format: off
const CR_TANF_CN = NTuple{4, Float64}((
    0x1.921fb54442d18p+0, -0x1.fd226e573289fp-2, 0x1.b7a60c8dac9f6p-6, -0x1.725beb40f33e5p-13
))

const CR_TANF_CD = NTuple{4, Float64}((
    0x1p+0, -0x1.2395347fb829dp+0, 0x1.2313660f29c36p-3, -0x1.9a707ab98d1c1p-9
))

const CR_TANF_ST = Vector{Tuple{UInt32, Float32, Float32}}([
    (reinterpret(UInt32, Float32(0x1.143ec4p+0)), Float32(0x1.ddf9f6p+0), Float32(-0x1.891d24p-52)),
    (reinterpret(UInt32, Float32(0x1.ada6aap+27)), Float32(0x1.e80304p-3), Float32(0x1.419f46p-58)),
    (reinterpret(UInt32, Float32(0x1.af61dap+48)), Float32(0x1.60d1c8p-2), Float32(-0x1.2d6c3ap-55)),
    (reinterpret(UInt32, Float32(0x1.0088bcp+52)), Float32(0x1.ca1edp+0), Float32(0x1.f6053p-53)),
    (reinterpret(UInt32, Float32(0x1.f90dfcp+72)), Float32(0x1.597f9cp-1), Float32(0x1.925978p-53)),
    (reinterpret(UInt32, Float32(0x1.cc4e22p+85)), Float32(-0x1.f33584p+1), Float32(0x1.d7254ap-51)),
    (reinterpret(UInt32, Float32(0x1.a6ce12p+86)), Float32(-0x1.c5612ep-1), Float32(-0x1.26c33ep-53)),
    (reinterpret(UInt32, Float32(0x1.6a0b76p+102)), Float32(-0x1.e42a1ep+0), Float32(-0x1.1dc906p-52))
])

const CR_TANF_IPI = CR_SINF_IPI
#! format: on

"""
argument reduction
for `|z| < 2^28`, return `r` such that `2/pi*x = q + r`
"""
function _tanf_rltl(z::Float32)
    x = Float64(z)
    #= The constants in idh, idl approximate 2/pi.
        Since idh is representable on 28 bits, and x on 24 bits, idh is exact
    =#
    idl = -0x1.b1bbead603d8bp-32 * x
    idh = 0x1.45f306ep-1 * x
    id = _llvm_roundeven(idh)
    r = (idh - id) + idl
    q = Int64(id)
    return r, q
end

"""
argument reduction
same as rltl, but for `|x| >= 2^28`
"""
function _tanf_rbig(u::UInt32)
    e = Int((u >> 23) & UInt32(0xff))
    m = UInt64((u & (~UInt32(0) >> 9)) | (UInt32(1) << 23))
    m128 = UInt128(m)

    ipi = CR_TANF_IPI
    p0 = m128 * ipi[1]
    p1 = m128 * ipi[2] + (p0 >> 64)
    p2 = m128 * ipi[3] + (p1 >> 64)
    p3 = m128 * ipi[4] + (p2 >> 64)

    low64_mask = typemax(UInt64)
    p3h = UInt64(p3 >> 64)
    p3l = trunc(UInt64, p3 & low64_mask)
    p2l = trunc(UInt64, p2 & low64_mask)
    p1l = trunc(UInt64, p1 & low64_mask)
    k = e - 127  # NOTE: differ from `_sinf_rbig`
    s = k - 23

    #= in cr_tanf(), rbig() is called in the case 127+28 <= e < 0xff
        thus 155 <= e <= 254, which yields 28 <= k <= 127 and 5 <= s <= 104
    =#
    i, a = UInt64(0), UInt64(0)
    if s < 64
        i = p3h << s | p3l >> (64 - s)
        a = p3l << s | p2l >> (64 - s)
    elseif s == 64
        i = p3l
        a = p2l
    else  # s > 64
        i = p3l << (s - 64) | p2l >> (128 - s)
        a = p2l << (s - 64) | p1l >> (128 - s)
    end
    i = i % Int64
    # NOTE: Keep signbit
    a = reinterpret(Int64, a)

    sgn = reinterpret(Int32, u) >> 31
    sm = a >> 63
    i -= sm
    z = (a ⊻ sgn) * 0x1p-64
    i = (i ⊻ sgn) - sgn
    q = i
    return Float64(z), Int64(q)
end

"""
Lookup database, check if `tu` is a hard to round case, if not return `r1`.
"""
function _tanf_database(tu::UInt32, r1::Float32)
    ax = tu & (~UInt32(0) >> 1)
    sgn = tu >> 31
    for (uarg, rh, rl) in CR_TANF_ST
        if @unlikely(ax == uarg)
            if sgn != 0
                return -rh - rl
            else
                return rh + rl
            end
        end
    end

    return r1
end

"""
    cr_tan(x::Float32)

Correctly-rounded tangent of `Float32`.

# Examples
```jldoctest
```

# Reference
- [core-math/src/binary32/tan/tanf.c](https://github.com/inkydragon/core-math/blob/7c7afc5d93cc3af4ff584f40f4a20af71488122a/src/binary32/tan/tanf.c)
"""
cr_tan(x::Float32) = cr_tanf(x)

function cr_tanf(x::Float32)
    tu = reinterpret(UInt32, x)
    e = (tu >> 23) & 0xff

    z, i = Float64(0.0), Int64(0)
    if @likely(e < (127 + 28))
        # |x| < 2^28
        if @unlikely(e < 115)
            # |x| < 2^-13
            if @unlikely(e < 102)
                # |x| < 2^-26
                #= The Taylor expansion of tan(x) at x=0 is x + x^3/3 + o(x^3),
                    thus for |x| >= 2^-126 we have no underflow, whatever the
                    rounding mode.
                    For |x| < 2^-126 and rounding towards zero, we have underflow.
                    For x = nextbelow(2^-126) = 0x1.fffffcp-127, tan(x) would round
                    upward to 0x1.fffffep-127 with unbounded exponent range, which is
                    not representable, thus we have underflow too.
                    In summary, we have underflow whenever |x| < 2^-126.
                =#
                # if x != 0.0 && abs(x) < Float32(0x1p-126)
                #     # errno = ERANGE  # underflow
                # end
                return fma(x, abs(x), x)
            end
            x2 = x * x
            return fma(x, Float32(0x1.555556p-2) * x2, x)
        end
        z, i = _tanf_rltl(x)
    elseif e < 0xff
        # e in [127+28, 127+127]
        #   |x| in [2^28, ?*2^127]
        z, i = _tanf_rbig(tu)
    else
        # e = 0xff:  NaN, Inf
        if (tu << 9) != 0
            # tan(NaN) = NaN
            return x + x
        end
        # errno = EDOM
        # tan(Inf) = NaN
        return NaN32
    end

    z2 = z * z
    z4 = z2 * z2
    cn = CR_TANF_CN
    cd = CR_TANF_CD
    s = (0.0, 1.0)
    n = cn[1] + z2 * cn[2]
    n2 = cn[3] + z2 * cn[4]
    n += z4 * n2
    d = cd[1] + z2 * cd[2]
    d2 = cd[3] + z2 * cd[4]
    d += z4 * d2
    n *= z
    s0 = s[(i&1)+1]
    s1 = s[1-(i&1)+1]
    r1 = (n * s1 - d * s0) / (n * s0 + d * s1)

    tru = reinterpret(UInt64, r1)
    tail = (tru + 7) & (~UInt64(0) >> 35)
    if @unlikely(tail <= 14)
        return _tanf_database(tu, Float32(r1))
    end

    return Float32(r1)
end
