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


function _asinf_as_special(x::Float32)
    t = reinterpret(UInt32, x)
    ax = t << 1
    if ax > (0x000_00ff << 24)
        return x  # nan
    end

    # to raise FE_INVALID (NaN generation)
    return 0.0f0 / 0.0f0
end

function cr_asinf(x::Float32)
    """Correctly-rounded arc-sine function for Float32.
    """
    pi2 = Float64(0x1.921fb54442d18p+0)

    xs = Float64(x)
    r = Float64(0.0)
    t = reinterpret(UInt32, x)
    ax = t << UInt32(1)

    if @unlikely(ax > (0x0000_007f << 24))
        # abs(x) > 1.0
        return _asinf_as_special(x)
    end

    if @likely(ax < 0x7ec29000)
        # abs(x) < 0.8800049f0
        if @unlikely(ax < UInt32(115 << 24))
            return fma(x, Float32(0x1p-25), x)
        end

        z = xs
        z2 = z * z
        z4 = z2 * z2
        z8 = z4 * z4
        z16 = z8 * z8
        b = CR_ASINF_B
        r = z * (
            (((b[1] + z2*b[2]) + z4*(b[3] + z2*b[4]))
                + z8*((b[5] + z2*b[6]) + z4*(b[7] + z2*b[8])))
            + z16*(
                ((b[9] + z2*b[10]) + z4*(b[11] + z2*b[12]))
                + z8*((b[13] + z2*b[14]) + z4*(b[15] + z2*b[16])))
        )
        ub = Float32(r)
        lb = Float32(r - z * 0x1.efa8ebp-31)
        if ub == lb
            return ub
        end
    end

    if ax < (0x0000_007e << 24)
        # abs(x) < 0.5
        z = xs
        z2 = z * z
        c0 = poly12(z2, CR_ASINF_C1)
        r = z + (z * z2) * c0
    else
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
        r = Base.Math.copysign(r, xs)
    end

    return Float32(r)
end
