# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/sinpi/sinpif.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

const CR_SINPIF_SN = NTuple{3, Float64}((
    0x1.921fb54442d0fp-37, -0x1.4abbce6102b94p-112, 0x1.4669fa3c58463p-189
))
const CR_SINPIF_CN = NTuple{3, Float64}((
    -0x1.3bd3cc9be45cfp-74, 0x1.03c1f08088742p-150, -0x1.55d1e5eff55a5p-228
))
const CR_SINPIF_S = Float64[
    0x0p+0, 0x1.91f65f10dd814p-5, 0x1.917a6bc29b42cp-4, 0x1.2c8106e8e613ap-3, 0x1.8f8b83c69a60bp-3, 0x1.f19f97b215f1bp-3,
    0x1.294062ed59f06p-2, 0x1.58f9a75ab1fddp-2, 0x1.87de2a6aea963p-2, 0x1.b5d1009e15ccp-2, 0x1.e2b5d3806f63bp-2,
    0x1.073879922ffeep-1, 0x1.1c73b39ae68c8p-1, 0x1.30ff7fce17035p-1, 0x1.44cf325091dd6p-1, 0x1.57d69348cecap-1,
    0x1.6a09e667f3bcdp-1, 0x1.7b5df226aafafp-1, 0x1.8bc806b151741p-1, 0x1.9b3e047f38741p-1, 0x1.a9b66290ea1a3p-1,
    0x1.b728345196e3ep-1, 0x1.c38b2f180bdb1p-1, 0x1.ced7af43cc773p-1, 0x1.d906bcf328d46p-1, 0x1.e212104f686e5p-1,
    0x1.e9f4156c62ddap-1, 0x1.f0a7efb9230d7p-1, 0x1.f6297cff75cbp-1, 0x1.fa7557f08a517p-1, 0x1.fd88da3d12526p-1,
    0x1.ff621e3796d7ep-1,0x1p+0, 0x1.ff621e3796d7ep-1, 0x1.fd88da3d12526p-1, 0x1.fa7557f08a517p-1, 0x1.f6297cff75cbp-1,
    0x1.f0a7efb9230d7p-1, 0x1.e9f4156c62ddap-1, 0x1.e212104f686e5p-1, 0x1.d906bcf328d46p-1, 0x1.ced7af43cc773p-1,
    0x1.c38b2f180bdb1p-1, 0x1.b728345196e3ep-1, 0x1.a9b66290ea1a3p-1, 0x1.9b3e047f38741p-1, 0x1.8bc806b151741p-1,
    0x1.7b5df226aafafp-1, 0x1.6a09e667f3bcdp-1, 0x1.57d69348cecap-1, 0x1.44cf325091dd6p-1, 0x1.30ff7fce17035p-1,
    0x1.1c73b39ae68c8p-1, 0x1.073879922ffeep-1, 0x1.e2b5d3806f63bp-2, 0x1.b5d1009e15ccp-2, 0x1.87de2a6aea963p-2,
    0x1.58f9a75ab1fddp-2, 0x1.294062ed59f06p-2, 0x1.f19f97b215f1bp-3, 0x1.8f8b83c69a60bp-3, 0x1.2c8106e8e613ap-3,
    0x1.917a6bc29b42cp-4, 0x1.91f65f10dd814p-5,0x0p+0, -0x1.91f65f10dd814p-5, -0x1.917a6bc29b42cp-4, -0x1.2c8106e8e613ap-3,
    -0x1.8f8b83c69a60bp-3, -0x1.f19f97b215f1bp-3, -0x1.294062ed59f06p-2, -0x1.58f9a75ab1fddp-2, -0x1.87de2a6aea963p-2,
    -0x1.b5d1009e15ccp-2, -0x1.e2b5d3806f63bp-2, -0x1.073879922ffeep-1, -0x1.1c73b39ae68c8p-1, -0x1.30ff7fce17035p-1,
    -0x1.44cf325091dd6p-1, -0x1.57d69348cecap-1, -0x1.6a09e667f3bcdp-1, -0x1.7b5df226aafafp-1, -0x1.8bc806b151741p-1,
    -0x1.9b3e047f38741p-1, -0x1.a9b66290ea1a3p-1, -0x1.b728345196e3ep-1, -0x1.c38b2f180bdb1p-1, -0x1.ced7af43cc773p-1,
    -0x1.d906bcf328d46p-1, -0x1.e212104f686e5p-1, -0x1.e9f4156c62ddap-1, -0x1.f0a7efb9230d7p-1, -0x1.f6297cff75cbp-1,
    -0x1.fa7557f08a517p-1, -0x1.fd88da3d12526p-1, -0x1.ff621e3796d7ep-1,-0x1p+0, -0x1.ff621e3796d7ep-1,
    -0x1.fd88da3d12526p-1, -0x1.fa7557f08a517p-1, -0x1.f6297cff75cbp-1, -0x1.f0a7efb9230d7p-1, -0x1.e9f4156c62ddap-1,
    -0x1.e212104f686e5p-1, -0x1.d906bcf328d46p-1, -0x1.ced7af43cc773p-1, -0x1.c38b2f180bdb1p-1, -0x1.b728345196e3ep-1,
    -0x1.a9b66290ea1a3p-1, -0x1.9b3e047f38741p-1, -0x1.8bc806b151741p-1, -0x1.7b5df226aafafp-1, -0x1.6a09e667f3bcdp-1,
    -0x1.57d69348cecap-1, -0x1.44cf325091dd6p-1, -0x1.30ff7fce17035p-1, -0x1.1c73b39ae68c8p-1, -0x1.073879922ffeep-1,
    -0x1.e2b5d3806f63bp-2, -0x1.b5d1009e15ccp-2, -0x1.87de2a6aea963p-2, -0x1.58f9a75ab1fddp-2, -0x1.294062ed59f06p-2,
    -0x1.f19f97b215f1bp-3, -0x1.8f8b83c69a60bp-3, -0x1.2c8106e8e613ap-3, -0x1.917a6bc29b42cp-4, -0x1.91f65f10dd814p-5
]


"""
Correctly-rounded sine of `Float32` value for angles.

# Reference
- https://gitlab.inria.fr/core-math/core-math/-/blob/03c15350fdcc286625bc5fe9b57e47a2275af293/src/binary32/sinpi/sinpif.c
"""
function cr_sinpif(x::Float32)
    sn = CR_SINPIF_SN
    cn = CR_SINPIF_CN
    S = CR_SINPIF_S

    ixu = reinterpret(UInt32, x)
    e = Int32((ixu >> 23) & 0xff)
    if @unlikely(e == 0xff)
        if (ixu << 9) == 0
            return Float32(NaN)
        end
        return x + x  # NaN
    end

    m = Int32((ixu & (~UInt32(0) >> 9)) | (Int32(1) << 23))
    sgn = reinterpret(Int32, ixu) >> 31
    m = (m ⊻ sgn) - sgn
    m_u32 = reinterpret(UInt32, m)
    s = Int32(143 - e)
    if @unlikely(s < 0)
        # |x| >= 0x1p+17
        if @unlikely(s < -6)
            # |x| >= 0x1p+23
            return copysign(Float32(0.0), x)
        end

        iq = m_u32 << (-s - 1)
        iq &= 127
        if iq == 0 || iq == 64
            return copysign(Float32(0.0), x)
        end
        return Float32(S[iq + 1])
    elseif @unlikely(s > 30)
        # |x| < 0x1p-14
        z = Float64(x)
        z2 = z * z
        return Float32(z * (0x1.921fb54442d18p+1 + z2 * (-0x1.4abbce625be53p+2)))
    end

    si = Int32(25 - s)
    if @unlikely(si >= 0 && (m_u32 << si) == 0)
        return copysign(Float32(0.0), x)
    end

    k = reinterpret(Int32, m_u32 << (31 - s))
    z = Float64(k)
    z2 = z * z
    fs = sn[1] + z2 * (sn[2] + z2 * sn[3])
    fc = cn[1] + z2 * (cn[2] + z2 * cn[3])
    iq = reinterpret(UInt32, m >> s)
    iq = UInt32((iq + 1) >> 1)
    is = UInt32(iq & 127)
    ic = UInt32((iq + 32) & 127)
    ts = S[is + 1]
    tc = S[ic + 1]
    r = ts + (ts * z2) * fc + (tc * z) * fs
    return Float32(r)
end
