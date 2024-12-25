# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/tanh/tanhf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

const CR_TANHF_CN = NTuple{8, Float64}((
    0x1p+0, 0x1.30877b8b72d33p-3,
    0x1.694aa09ae9e5ep-8, 0x1.4101377abb729p-14,
    0x1.e0392b1db0018p-22, 0x1.2533756e546f7p-30,
    0x1.d62e5abe6ae8ap-41, 0x1.b06be534182dep-54
))

const CR_TANHF_CD = NTuple{8, Float64}((
    0x1p+0, 0x1.ed99131b0ebeap-2,
    0x1.0d27ed6c95a69p-5, 0x1.7cbdaca0e9fccp-11,
    0x1.b4e60b892578ep-18, 0x1.a6f707c5c71abp-26,
    0x1.35a8b6e2cd94cp-35, 0x1.ca8230677aa01p-47
))

"""Correctly-rounded hyperbolic tangent function of Float32.
"""
function cr_tanhf(x::Float32)::Float32
    ux = reinterpret(UInt32, x)
    e = (ux >> 23) & 0xff

    if @unlikely(e == 0xff)
        if (ux << 9) != 0
            # x = nan
            return x + x
        end
        # x = +-Inf
        ir = (1.0f0, -1.0f0)
        return ir[(ux >> 31) + 1]
    end

    if @unlikely(e < 115)
        if @unlikely(e < 102)
            if @unlikely((ux << 1) == 0)
                return x
            end

            return fma(-x, abs(x), x)
        end

        x2 = x * x
        return fma(x, Float32(-0x1.555556p-2) * x2, x)
    end

    if (ux << 1) > (0x41102cb3 << 1)
        # abs(x) > 9.010913f0
        return copysign(1.0f0, x) - copysign(Float32(0x1p-25), x)
    end

    z = Float64(x)
    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4

    cn = CR_TANHF_CN
    cd = CR_TANHF_CD
    n0 = cn[1] + z2 * cn[2]
    n2 = cn[3] + z2 * cn[4]
    n4 = cn[5] + z2 * cn[6]
    n6 = cn[7] + z2 * cn[8]
    n0 += z4 * n2
    n4 += z4 * n6
    n0 += z8 * n4

    d0 = cd[1] + z2 * cd[2]
    d2 = cd[3] + z2 * cd[4]
    d4 = cd[5] + z2 * cd[6]
    d6 = cd[7] + z2 * cd[8]
    d0 += z4 * d2
    d4 += z4 * d6
    d0 += z8 * d4

    r = z * n0 / d0
    return r
end

tanh(x::Float32) = cr_tanhf(x)
