# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/cos/cosf.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

const CR_COSF_TB = NTuple{32, Float64}((
    0x1p+0, 0x1.f6297cff75cbp-1, 0x1.d906bcf328d46p-1, 0x1.a9b66290ea1a3p-1,
    0x1.6a09e667f3bcdp-1, 0x1.1c73b39ae68c8p-1, 0x1.87de2a6aea963p-2, 0x1.8f8b83c69a60bp-3,
    0x0p+0, -0x1.8f8b83c69a60bp-3, -0x1.87de2a6aea963p-2, -0x1.1c73b39ae68c8p-1,
    -0x1.6a09e667f3bcdp-1, -0x1.a9b66290ea1a3p-1, -0x1.d906bcf328d46p-1, -0x1.f6297cff75cbp-1,
    -0x1p+0, -0x1.f6297cff75cbp-1, -0x1.d906bcf328d46p-1, -0x1.a9b66290ea1a3p-1,
    -0x1.6a09e667f3bcdp-1, -0x1.1c73b39ae68c8p-1, -0x1.87de2a6aea963p-2, -0x1.8f8b83c69a60bp-3,
    0x0p+0, 0x1.8f8b83c69a60bp-3, 0x1.87de2a6aea963p-2, 0x1.1c73b39ae68c8p-1,
    0x1.6a09e667f3bcdp-1, 0x1.a9b66290ea1a3p-1, 0x1.d906bcf328d46p-1, 0x1.f6297cff75cbp-1
))


function _cosf_absc(z::Float64, ia::Int64)
    z2 = z * z
    z4 = z2 * z2
    a, b = CR_SINF_A, CR_SINF_B
    aa = (a[1] + z2 * a[2]) + z4 * (a[3] + z2 * a[4])
    bb = (b[1] + z2 * b[2]) + z4 * (b[3] + z2 * b[4])
    s0 = CR_COSF_TB[((ia+8) & 31) + 1]
    c0 = CR_COSF_TB[(ia & 31) + 1]
    return aa, bb, s0, c0
end

function _cosf_big(x::Float32)::Float32
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax >= (UInt32(0xff) << 24))  # nan or +-inf
        if (ax << 8) != 0
            return x + x  # NaN
        end
        return 0.0f0 / 0.0f0 # to raise FE_INVALID
    end

    z, ia = _sinf_rbig(tu)
    aa, bb, s0, c0 = _cosf_absc(z, ia)
    r = c0 + z*(aa*s0 - bb*(z*c0))
    tru = reinterpret(UInt64, r)

    tail = (tru + UInt64(6)) & (~UInt64(0) >> 36);
    if tail <= 12
        return _cosf_database(x, r)
    end

    return r
end


const CR_COSF_ST = Vector{Tuple{UInt32, Float32, Float32}}([
    # 4.712389f0 (0x1.2d97c8p+2)
    (0x4096cbe4, Float32(0x1.99bc5cp-27), Float32(-0x1p-52)),
    # 2.8616508f15 (0x1.4555p+51)
    (0x5922aa80, Float32(0x1.115d7ep-1), Float32(-0x1p-26)),
    # 2.3127222f16 (0x1.48a858p+54)
    (0x5aa4542c, Float32(0x1.f48148p-2), Float32(0x1p-27)),
    # 1.1004678f19 (0x1.3170fp+63)
    (0x5f18b878, Float32(0x1.fe2976p-1), Float32(0x1p-26)),
    # 1.7269983f20 (0x1.2b9622p+67)
    (0x6115cb11, Float32(0x1.f0285ep-1), Float32(-0x1p-26))
])

function _cosf_database(x::Float32, r::Float64)::Float32
    tu = reinterpret(UInt32, x)
    ax = tu & (~UInt32(0) >> 1)
    for (uarg, rh, rl) in CR_COSF_ST
        if uarg == ax
            return rh + rl
        end
    end

    return r
end

"""
Correctly-rounded cosine of `Float32`.
"""
function cr_cosf(x::Float32)::Float32
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax > 0x99000000 || ax < 0x73000000)
        if @likely(ax < 0x73000000)
            if @unlikely(ax < 0x66000000)
                if @unlikely(ax == 0)
                    return 1.0f0
                end
                return 1.0f0 - Float32(0x1p-25)
            end
            return -Float32(0x1p-1) * x * x + 1.0f0
        end
        return _cosf_big(x)
    end

    z0 = Float64(x)
    z, ia = Float64(0.0), Int64(0)
    if @likely(ax < 0x82a41896)
        if @unlikely(ax == 0x812d97c8)
            return _cosf_database(x, 0.0)
        end
        z, ia = rltl0(z0)
    else
        z, ia = rltl(z0)
    end

    aa, bb, s0, c0 = _cosf_absc(z, ia)
    z2 = z * z
    r = c0 + aa*(z*s0) - bb*(z2*c0)
    return r
end
