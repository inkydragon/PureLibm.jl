# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan/atanf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

const CR_TANPIF_CN = NTuple{4,Float64}((
    0x1.921fb54442d19p-1,
    -0x1.1f458b3e1f8d6p-2,
    0x1.68a34bd0b8f6ap-6,
    -0x1.e4866f7a25f99p-13,
))
const CR_TANPIF_CD = NTuple{4,Float64}((
    0x1p+0, -0x1.4b4b98d2df3a7p-1, 0x1.8e9926d2bb901p-4, -0x1.a6f77fd847eep-9
))

"""
Correctly-rounded tangent of `Float32` for angles.
"""
function cr_tanpif(x::Float32)
    ixu = reinterpret(UInt32, x)
    e = ixu & (UInt32(0xff) << 23)
    if @unlikely(e > (150 << 23))
        # |x| > 2^23
        if e == (UInt32(0xff) << 23)
            # NaN or Inf
            if (ixu << 9) == 0
                # tanpi(Inf)
                return NaN32
            end
            return x + x  # NaN
        end
        return copysign(0.0f0, x)
    end

    x4 = 4.0f0 * x
    nx4 = _llvm_roundeven(x4)
    dx4 = x4 - nx4
    ni = _llvm_roundeven(x)
    zf = x - ni

    if @unlikely(dx4 == 0)
        # 4*x is integer
        k = trunc(Int, x4)
        if k & 1 != 0
            # x = 1/4 mod 1/2
            return copysign(1.0f0, zf)
        end

        k &= 6
        if k == 0
            # x = 0 mod 2
            return copysign(0.0f0, x)
        elseif k == 4
            # x = 1 mod 2
            return -copysign(0.0f0, x)
        elseif k == 2
            # x = 1/2 mod 2
            return 1.0f0 / 0.0f0
        else
            # now necessarily k=6
            # x = -1/2 mod 2
            return -1.0f0 / 0.0f0
        end
    end

    # Special rounding correction cases
    a = reinterpret(UInt32, zf) & ((~UInt32(0)) >> 1)
    if @unlikely(a == 0x3e933802)
        # x=0x1.267004p-2 is not correctly rounded for RNDZ/RNDD by the code below
        return copysign(Float32(0x1.44cfbap+0), zf) + copysign(Float32(0x1p-25), zf)
    elseif @unlikely(a == 0x38f26685)
        # x=-0x1.e4cd0ap-14 is not correctly rounded for RNDU by the code below
        return copysign(Float32(0x1.7cc304p-12), zf) + copysign(Float32(0x1p-37), zf)
    end

    z = Float64(zf)
    z2 = z * z
    z4 = z2 * z2
    cn = CR_TANPIF_CN
    cd = CR_TANPIF_CD
    num = (cn[1] + z2 * cn[2]) + z4 * (cn[3] + z2 * cn[4])
    den = (cd[1] + z2 * cd[2]) + z4 * (cd[3] + z2 * cd[4])
    den *= (0.25 - z2)
    r = (z - z * z2) * num / den
    return Float32(r)
end
