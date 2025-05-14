# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/expm1/expm1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

const CR_EXPM1F_C = NTuple{4, Float64}((
    1,
    0x1.62e42fef4c4e7p-6,
    0x1.ebfd1b232f475p-13,
    0x1.c6b19384ecd93p-20
))
const CR_EXPM1F_CH = NTuple{6, Float64}((
    0x1.62e42fefa39efp-6,
    0x1.ebfbdff82c58fp-13,
    0x1.c6b08d702e0edp-20,
    0x1.3b2ab6fb92e5ep-27,
    0x1.5d886e6d54203p-35,
    0x1.430976b8ce6efp-43
))
const CR_EXPM1F_TD = NTuple{32, Float64}((
    0x1p+0, 0x1.059b0d3158574p+0, 0x1.0b5586cf9890fp+0, 0x1.11301d0125b51p+0,
    0x1.172b83c7d517bp+0, 0x1.1d4873168b9aap+0, 0x1.2387a6e756238p+0, 0x1.29e9df51fdee1p+0,
    0x1.306fe0a31b715p+0, 0x1.371a7373aa9cbp+0, 0x1.3dea64c123422p+0, 0x1.44e086061892dp+0,
    0x1.4bfdad5362a27p+0, 0x1.5342b569d4f82p+0, 0x1.5ab07dd485429p+0, 0x1.6247eb03a5585p+0,
    0x1.6a09e667f3bcdp+0, 0x1.71f75e8ec5f74p+0, 0x1.7a11473eb0187p+0, 0x1.82589994cce13p+0,
    0x1.8ace5422aa0dbp+0, 0x1.93737b0cdc5e5p+0, 0x1.9c49182a3f09p+0, 0x1.a5503b23e255dp+0,
    0x1.ae89f995ad3adp+0, 0x1.b7f76f2fb5e47p+0, 0x1.c199bdd85529cp+0, 0x1.cb720dcef9069p+0,
    0x1.d5818dcfba487p+0, 0x1.dfc97337b9b5fp+0, 0x1.ea4afa2a490dap+0, 0x1.f50765b6e454p+0
))
const CR_EXPM1F_B = NTuple{8, Float64}((
    0x1.fffffffffffc2p-2, 0x1.55555555555fep-3, 0x1.555555559767fp-5, 0x1.1111111098dc1p-7,
    0x1.6c16bca988aa9p-10, 0x1.a01a07658483fp-13, 0x1.a05b04d2c3503p-16, 0x1.71de3a960b5e3p-19
))

"""
Correctly-rounded `exp(x) - 1` function for `Float32`.

# Reference
- https://gitlab.inria.fr/core-math/core-math/-/blob/345beda118d10da08ad2461fcac244e8e32d37de/src/binary32/expm1/expm1f.c
"""
function cr_expm1f(x::Float32)
    iln2 = 0x1.71547652b82fep+5
    big = 0x1.8p52

    ux = reinterpret(UInt32, x)
    ax = ux << 1
    z = Float64(x)
    if @likely(ax < 0x7c400000)
        # |x| < 0.15625
        if @unlikely(ax < 0x676a09e8)
            # |x| < 0x1.6a09e8p-24
            if @unlikely(ax == 0x0)
                # x = +-0
                return x
            end
            res = fma(abs(x), Float32(0x1p-25), x)
            return res
        end

        z2 = z * z
        z4 = z2 * z2
        b = CR_EXPM1F_B
        r = z +
            z2 * ((b[1] + z * b[2]) + z2 * (b[3] + z * b[4]) +
             z4 * ((b[5] + z * b[6]) + z2 * b[7]))
        return Float32(r)
    end

    if @unlikely(ax >= 0x8562e430)
        # |x| > 88.72
        if ax > (UInt32(0xff) << 24)
            return x + x  # NaN
        end
        if @unlikely(ux >> 31 != 0)
            # x < 0
            if ax == (UInt32(0xff) << 24)
                return -1.0f0
            end
            return -1.0f0 + Float32(0x1p-26)
        end
        if ax == (UInt32(0xff) << 24)
            return Inf32
        end
        r = 0x1.fffffep127 * x
        return Float32(r)
    end

    a = iln2 * z
    ia = _llvm_roundeven(a)
    h = a - ia
    h2 = h * h
    uu = reinterpret(UInt64, Float64(ia + big))
    c = CR_EXPM1F_C
    c2 = c[3] + c[4] * h
    c0 = c[1] + c[2] * h
    svu = reinterpret(UInt64, CR_EXPM1F_TD[(uu & 0x1f) + 1]) + (uu >> 5) << 52
    svf = reinterpret(Float64, svu)
    r = (c0 + h2 * c2) * svf - 1.0

    ub = Float32(r)
    lb = Float32(r - svf * 0x1.3b3p-33)
    if @unlikely(ub != lb)
        if @unlikely(ux > 0xc18aa123)
            # x < -17.32
            return -1.0f0 + Float32(0x1p-26)
        end
        iln2h = 0x1.7154765p+5
        iln2l = 0x1.5c17f0bbbe88p-26
        s = Float64(svf)
        h = (iln2h * z - ia) + iln2l * z
        h2 = h * h
        w = s * h
        ch = CR_EXPM1F_CH
        r = (s - 1.0) +
            w *
            ((ch[1] + h * ch[2]) + h2 * ((ch[3] + h * ch[4]) + h2 * (ch[5] + h * ch[6])))
        ub = Float32(r)
    end

    return ub
end
