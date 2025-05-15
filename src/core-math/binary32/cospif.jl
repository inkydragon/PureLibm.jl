# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/cospi/cospif.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

const CR_COSPIF_SN = NTuple{3, Float64}((
    0x1.921fb54442d0fp-37, -0x1.4abbce6102b94p-112, 0x1.4669fa3c58463p-189
))
const CR_COSPIF_CN = NTuple{3, Float64}((
    -0x1.3bd3cc9be45cfp-74, 0x1.03c1f08088742p-150, -0x1.55d1e5eff55a5p-228
))
"""
S[i] approximates sin(i*pi/2^6)
"""
const CR_COSPIF_S = Float64[
    0x0p+0, 0x1.91f65f10dd814p-5, 0x1.917a6bc29b42cp-4, 0x1.2c8106e8e613ap-3, 0x1.8f8b83c69a60bp-3, 0x1.f19f97b215f1bp-3,
    0x1.294062ed59f06p-2, 0x1.58f9a75ab1fddp-2, 0x1.87de2a6aea963p-2, 0x1.b5d1009e15ccp-2, 0x1.e2b5d3806f63bp-2,
    0x1.073879922ffeep-1, 0x1.1c73b39ae68c8p-1, 0x1.30ff7fce17035p-1, 0x1.44cf325091dd6p-1, 0x1.57d69348cecap-1,
    0x1.6a09e667f3bcdp-1, 0x1.7b5df226aafafp-1, 0x1.8bc806b151741p-1, 0x1.9b3e047f38741p-1, 0x1.a9b66290ea1a3p-1,
    0x1.b728345196e3ep-1, 0x1.c38b2f180bdb1p-1, 0x1.ced7af43cc773p-1, 0x1.d906bcf328d46p-1, 0x1.e212104f686e5p-1,
    0x1.e9f4156c62ddap-1, 0x1.f0a7efb9230d7p-1, 0x1.f6297cff75cbp-1, 0x1.fa7557f08a517p-1, 0x1.fd88da3d12526p-1,
    0x1.ff621e3796d7ep-1, 0x1p+0, 0x1.ff621e3796d7ep-1, 0x1.fd88da3d12526p-1, 0x1.fa7557f08a517p-1, 0x1.f6297cff75cbp-1,
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
Correctly-rounded cosine of `Float32` for angles.
"""
function cr_cospif(x::Float32)
    S = CR_COSPIF_S

    ixu = reinterpret(UInt32, x)
    e = (ixu >> 23) & UInt32(0xff)
    if (e == 0xff)
        if (ixu << 9) == 0
            # feraiseexcept(FE_INVALID)
            return NaN32
        end
        return x + x  # NaN
    end

    mu = (ixu & (~UInt32(0) >> 9)) | (UInt32(1) << 23)
    m = reinterpret(Int32, mu)
    s = 143 - e
    p = e - 112
    if (p < 0)
        # |x| < 2^-15
        ax = ixu & (~UInt32(0) >> 1)
        if ax >= UInt32(0x19f030)
            # Warning: -0x1.3bd3ccp+2f * x underflows for |x| < 0x1.9f03p-129
            return fma(-Float32(0x1.3bd3ccp+2) * x, x, 1.0f0)
        else
            # |x| < 0x1.9f03p-129
            return fma(-x, x, 1.0f0)
        end
    end

    if (p > 31)
        if (p > 63)
            return Float32(1.0)
        end
        iq = reinterpret(Int32, mu << (p - 32))
        return Float32(S[(iq + 32) & 127 + 1])
    end

    k = reinterpret(Int32, mu << p)
    if (k == 0)
        iq = m >> (32 - p)
        return Float32(S[(iq + 32) & 127 + 1])
    end

    z = Float64(k)
    z2 = z * z
    sn = CR_COSPIF_SN
    cn = CR_COSPIF_CN
    fs = sn[1] + z2 * (sn[2] + z2 * sn[3])
    fc = cn[1] + z2 * (cn[2] + z2 * cn[3])
    iq = UInt32(mu >> s)
    iq = UInt32(iq + 1) >> 1
    is = iq & 127
    ic = UInt32(iq + 32) & 127
    ts = S[ic + 1]
    tc = S[is + 1]
    r = ts + (ts * z2) * fc - (tc * z) * fs
    return Float32(r)
end
