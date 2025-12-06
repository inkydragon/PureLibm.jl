# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/sin/sinf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

const CR_SINF_IPI = NTuple{4, UInt64}((
    0xfe5163abdebbc562, 0xdb6295993c439041,
    0xfc2757d1f534ddc0, 0xa2f9836e4e441529
))

const CR_SINF_A = NTuple{4, Float64}((
    0x1.921fb54442d17p-3, -0x1.4abbce6256a39p-10,
    0x1.466bc5a518c16p-19, -0x1.32bdc61074ff6p-29
))

const CR_SINF_B = NTuple{4, Float64}((
    0x1.3bd3cc9be45dcp-6, -0x1.03c1f081b0833p-14,
    0x1.55d3c6fc9ac1fp-24, -0x1.e1d3ff281b40dp-35
))

const CR_SINF_TB = NTuple{32, Float64}((
    0x0p+0, 0x1.8f8b83c69a60bp-3, 0x1.87de2a6aea963p-2, 0x1.1c73b39ae68c8p-1,
    0x1.6a09e667f3bcdp-1, 0x1.a9b66290ea1a3p-1, 0x1.d906bcf328d46p-1, 0x1.f6297cff75cbp-1,
    0x1p+0, 0x1.f6297cff75cbp-1, 0x1.d906bcf328d46p-1, 0x1.a9b66290ea1a3p-1,
    0x1.6a09e667f3bcdp-1, 0x1.1c73b39ae68c8p-1, 0x1.87de2a6aea963p-2, 0x1.8f8b83c69a60bp-3,
    0x0p+0, -0x1.8f8b83c69a60bp-3, -0x1.87de2a6aea963p-2, -0x1.1c73b39ae68c8p-1,
    -0x1.6a09e667f3bcdp-1, -0x1.a9b66290ea1a3p-1, -0x1.d906bcf328d46p-1, -0x1.f6297cff75cbp-1,
    -0x1p+0, -0x1.f6297cff75cbp-1, -0x1.d906bcf328d46p-1, -0x1.a9b66290ea1a3p-1,
    -0x1.6a09e667f3bcdp-1, -0x1.1c73b39ae68c8p-1, -0x1.87de2a6aea963p-2, -0x1.8f8b83c69a60bp-3
))


function _sinf_rbig(u::UInt32)
    e = Int((u >> 23) & UInt32(0xff))
    m = UInt64((u & (~UInt32(0) >> 9)) | (UInt32(1) << 23))
    m128 = UInt128(m)

    ipi = CR_SINF_IPI
    p0 = m128 * ipi[1]
    p1 = m128 * ipi[2] + (p0 >> 64)
    p2 = m128 * ipi[3] + (p1 >> 64)
    p3 = m128 * ipi[4] + (p2 >> 64)

    low64_mask = typemax(UInt64)
    p3h = UInt64(p3 >> 64)
    p3l = trunc(UInt64, p3 & low64_mask)
    p2l = trunc(UInt64, p2 & low64_mask)
    p1l = trunc(UInt64, p1 & low64_mask)
    k = e - 124
    s = k - 23

    #= in cr_sinf(), rbig() is called in the case 127+28 <= e < 0xff
        thus 155 <= e <= 254, which yields 28 <= k <= 127 and 5 <= s <= 104
    =#
    @assert 153 <= e <= 254 "[u=$u] Bad e=$e"
    @assert 29 <= k <= 130  "[u=$u] Bad k=$k"
    @assert 6 <= s <= 107   "[u=$u] Bad s=$s"
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

function _sinf_absc(z::Float64, ia::Int64)
    z2 = z * z
    z4 = z2 * z2
    a, b = CR_SINF_A, CR_SINF_B
    aa = (a[1] + z2 * a[2]) + z4 * (a[3] + z2 * a[4])
    bb = (b[1] + z2 * b[2]) + z4 * (b[3] + z2 * b[4])
    s0 = CR_SINF_TB[(ia & 31) + 1]
    c0 = CR_SINF_TB[((ia+8) & 31) + 1]
    return aa, bb, s0, c0
end

function _sinf_big(x::Float32)::Float32
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax >= (UInt32(0xff) << 24))
        # nan or +-inf
        if (ax << 8) != 0
            # NaN
            return x + x
        end
        # to raise FE_INVALID
        return 0.0f0 / 0.0f0
    end

    z, ia = _sinf_rbig(tu)
    aa, bb, s0, c0 = _sinf_absc(z, ia)
    r = s0 + z * (aa * c0 - bb * (z * s0))
    return r
end

function add_sign(x::Float32, rh::Float32, rl::Float32)
    sgn = copysign(1.0f0, x)
    return sgn * rh + sgn * rl
end

const CR_SINF_ST = Vector{Tuple{UInt32, Float32, Float32}}([
    # 9830.398f0
    (0x46199998, Float32(-0x1.63f4bap-2), Float32(-0x1p-27)),
    # 0.72992426f0
    (0x3f3adc51, Float32(0x1.55688ap-1), Float32(-0x1p-26)),
    # 1.3086903f0
    (0x3fa7832a, Float32(0x1.ee836cp-1), Float32(-0x1p-26)),
    # 9.424778f0
    (0x4116cbe4, Float32(-0x1.99bc5ap-26), Float32(-0x1p-51)),
])

function _sinf_database(x::Float32, r::Float32)
    tu = reinterpret(UInt32, x)
    ax = tu & (~UInt32(0) >> 1)
    for (uarg, rh, rl) in CR_SINF_ST
        if @unlikely(uarg == ax)
            return add_sign(x, rh, rl)
        end
    end

    return r
end

function rltl0(x::Float64)
    idh = 0x1.45f306dc9c883p+2 * x
    id = _llvm_roundeven(idh)
    qf = 0x1.8p52 + id
    qu = reinterpret(UInt64, qf)
    return idh - id, Int64(qu)
end

function rltl(x::Float64)
    idl = -0x1.b1bbead603d8bp-29 * x
    idh = 0x1.45f306ep+2 * x
    id = _llvm_roundeven(idh)
    qf = 0x1.8p52 + id
    qu = reinterpret(UInt64, qf)
    return (idh - id) + idl, Int64(qu)
end

"""
    cr_sin(x::Float32)

Correctly-rounded sine of `Float32`.

# Reference
- [core-math/src/binary32/sin/sinf.c](https://github.com/inkydragon/core-math/blob/bbfabd993a71b049c210b0febfd06d18369fadc1/src/binary32/sin/sinf.c)
"""
cr_sin(x::Float32) = cr_sinf(x)

function cr_sinf(x::Float32)::Float32
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax > 0x99000000 || ax < 0x73000000)
        # |x| > 0x1p+26 or |x| < 0x1p-12
        # |x| > 6.7108864f7 or |x| < 0.00024414062f0
        if @likely(ax < 0x73000000)
            # |x| < 0x1p-12
            if @unlikely(ax < 0x66000000)
                # |x| < 0x1p-25
                if @unlikely(ax == 0)
                    return x
                end
                res = fma(-x, abs(x), x)
                #= The Taylor expansion of sin(x) at x=0 is x - x^3/6 + o(x^3).
                    For |x| > 2^-126 we have no underflow, whatever the rounding mode.
                    For |x| < 2^-126, since |sin(x)| < |x|, we always have underflow.
                    For |x| = 2^-126, we have underflow for rounding towards zero,
                    i.e., when sin(x) rounds to nextbelow(2^-126).
                    In summary, we have underflow whenever |x|<2^-126 or |res|<2^-126.
                =#
                # if abs(x) < 0x1p-126 || abs(res) < 0x1p-126
                #     errno = ERANGE  # underflow
                # end
                return res
            end
            return (-0x1.555556p-3 * x) * (x * x) + x
        end
        return _sinf_big(x)
    end

    z0 = Float64(x)
    z, ia = Float64(0.0), Int64(0)
    if @likely(ax < 0x822d97c8)
        if @unlikely(ax == 0x7e75b8a2 || ax == 0x7f4f0654)
            return _sinf_database(x, 0.0f0)
        end
        z, ia = rltl0(z0)
    else
        if @unlikely(ax == 0x8c333330)
            # add ax == 0x822d97c8
            return _sinf_database(x, 0.0f0)
        end
        z, ia = rltl(z0)
    end

    aa, bb, s0, c0 = _sinf_absc(z, ia)
    z2 = z * z
    r = s0 + aa * (z * c0) - bb * (z2 * s0)
    return r
end
