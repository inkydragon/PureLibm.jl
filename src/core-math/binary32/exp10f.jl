# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp10/exp10f.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

const CR_EXP10F_TB = NTuple{32, UInt64}((
    0x3ff0000000000000, 0x3ff059b0d3158574, 0x3ff0b5586cf9890f, 0x3ff11301d0125b51,
    0x3ff172b83c7d517b, 0x3ff1d4873168b9aa, 0x3ff2387a6e756238, 0x3ff29e9df51fdee1,
    0x3ff306fe0a31b715, 0x3ff371a7373aa9cb, 0x3ff3dea64c123422, 0x3ff44e086061892d,
    0x3ff4bfdad5362a27, 0x3ff5342b569d4f82, 0x3ff5ab07dd485429, 0x3ff6247eb03a5585,
    0x3ff6a09e667f3bcd, 0x3ff71f75e8ec5f74, 0x3ff7a11473eb0187, 0x3ff82589994cce13,
    0x3ff8ace5422aa0db, 0x3ff93737b0cdc5e5, 0x3ff9c49182a3f090, 0x3ffa5503b23e255d,
    0x3ffae89f995ad3ad, 0x3ffb7f76f2fb5e47, 0x3ffc199bdd85529c, 0x3ffcb720dcef9069,
    0x3ffd5818dcfba487, 0x3ffdfc97337b9b5f, 0x3ffea4afa2a490da, 0x3fff50765b6e4540
))

const CR_EXP10F_EX = NTuple{10, Float64}((
    10.0, 100.0, 1000.0, 10000.0,
    100000.0, 1000000.0, 10000000.0, 100000000.0,
    1000000000.0, 10000000000.0
))

const CR_EXP10F_B = NTuple{4, Float64}((
    1.0, 0x1.62e42fef4c4e7p-6, 0x1.ebfd1b232f475p-13, 0x1.c6b19384ecd93p-20
))

const CR_EXP10F_C = NTuple{6, Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c58fp-3, 0x1.c6b08d702e0edp-5,
    0x1.3b2ab6fb92e5ep-7, 0x1.5d886e6d54203p-10, 0x1.430976b8ce6efp-13
))


"""
    cr_exp10(x::Float32)

Correctly-rounded 10^x function for `Float32`.
"""
cr_exp10(x::Float32) = cr_exp10f(x)

function cr_exp10f(x::Float32)::Float32
    iln102 = 0x1.a934f0979a371p+6
    iln102h = 0x1.a934f09p+1
    iln102l = 0x1.e68dc57f2496p-29

    tu = reinterpret(UInt32, x)
    z = Float64(x)
    ux = tu << 1

    if @unlikely(ux > 0x84344134 || ux < 0x72adf1c6)
        # |x| > 38.531837f0 || |x| < 0.00020501348f0
        if ux < 0x72adf1c6  # |x| < 0.00020501348f0
            return Float32(1.0 + z * (0x1.26bb1bbb55516p+1 + z * (0x1.53524c73cea69p+1 + z * 0x1.0470591de2ca4p+1)))
        end
        if ux >= UInt32(0xff) << 24  # x is inf or nan
            if ux > UInt32(0xff) << 24
                return x + x  # NaN
            end
            ir = (Inf32, 0.0f0)
            return Float32(ir[(tu>>31)+1])  # +-inf
        end
        if tu > 0xc23369f4  # x > -44.85347f0
            y = 0x1p-149 + (z + 0x1.66d3e7bd9a403p+5) * 0x1.a934f0979a37p-149
            y = max(y, 0x1p-151)
            r = Float32(y)
            # if r == 0.0
            #     errno = ERANGE
            # end
            return r
        end
        if tu < 0x80000000  # x > 0; ==> x > 38.531837f0
            r = Float32(0x1p127) * Float32(0x1p127)
            # if r > 0x1.fffffep127
            #     errno = ERANGE
            # end
            return r
        end
    end

    if @unlikely((tu << 12) == 0)
        k = (tu >> 20) - UInt32(1016)
        if k <= 26
            bt = UInt32(1) << k
            msk = 0x0755_1101
            if (bt & msk) != 0
                idx = _llvm_popcount(msk & (bt-UInt32(1)))
                return Float32(CR_EXP10F_EX[idx+1])
            end
        end
    end

    a = iln102 * z
    ia = Float64(_llvm_roundeven(a))
    h = a - ia
    ja = Int64(ia)
    svu = CR_EXP10F_TB[(ja & 0x1f)+1] + ((ja >> 5) << 52)
    svf = reinterpret(Float64, svu)

    h2 = h * h
    b = CR_EXP10F_B
    r = ((b[1] + h * b[2]) + h2 * (b[3] + h * b[4])) * svf
    ub = Float32(r)
    lb = Float32(r - r * 1.45e-10)
    if @unlikely(ub != lb)
        h = (iln102h * z - ia * 0.03125) + iln102l * z
        s = svf
        h2 = h * h
        w = s * h
        c = CR_EXP10F_C
        r = s + w * (
            (c[1] + h * c[2])
            + h2 * ((c[3] + h * c[4]) + h2 * (c[5] + h * c[6])))
        ub = Float32(r)
    end

    return ub
end
