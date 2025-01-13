# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp2/exp2f.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

"""
```jl
[ reinterpret(UInt64, f) for f in CR_EXP2F_TB_F64 ] |> println
```
"""
const CR_EXP2F_TB = NTuple{64, UInt64}((
    0x3ff0000000000000, 0x3ff02c9a3e778061, 0x3ff059b0d3158574, 0x3ff0874518759bc8,
    0x3ff0b5586cf9890f, 0x3ff0e3ec32d3d1a2, 0x3ff11301d0125b51, 0x3ff1429aaea92de0,
    0x3ff172b83c7d517b, 0x3ff1a35beb6fcb75, 0x3ff1d4873168b9aa, 0x3ff2063b88628cd6,
    0x3ff2387a6e756238, 0x3ff26b4565e27cdd, 0x3ff29e9df51fdee1, 0x3ff2d285a6e4030b,
    0x3ff306fe0a31b715, 0x3ff33c08b26416ff, 0x3ff371a7373aa9cb, 0x3ff3a7db34e59ff7,
    0x3ff3dea64c123422, 0x3ff4160a21f72e2a, 0x3ff44e086061892d, 0x3ff486a2b5c13cd0,
    0x3ff4bfdad5362a27, 0x3ff4f9b2769d2ca7, 0x3ff5342b569d4f82, 0x3ff56f4736b527da,
    0x3ff5ab07dd485429, 0x3ff5e76f15ad2148, 0x3ff6247eb03a5585, 0x3ff6623882552225,
    0x3ff6a09e667f3bcd, 0x3ff6dfb23c651a2f, 0x3ff71f75e8ec5f74, 0x3ff75feb564267c9,
    0x3ff7a11473eb0187, 0x3ff7e2f336cf4e62, 0x3ff82589994cce13, 0x3ff868d99b4492ed,
    0x3ff8ace5422aa0db, 0x3ff8f1ae99157736, 0x3ff93737b0cdc5e5, 0x3ff97d829fde4e50,
    0x3ff9c49182a3f090, 0x3ffa0c667b5de565, 0x3ffa5503b23e255d, 0x3ffa9e6b5579fdbf,
    0x3ffae89f995ad3ad, 0x3ffb33a2b84f15fb, 0x3ffb7f76f2fb5e47, 0x3ffbcc1e904bc1d2,
    0x3ffc199bdd85529c, 0x3ffc67f12e57d14b, 0x3ffcb720dcef9069, 0x3ffd072d4a07897c,
    0x3ffd5818dcfba487, 0x3ffda9e603db3285, 0x3ffdfc97337b9b5f, 0x3ffe502ee78b3ff6,
    0x3ffea4afa2a490da, 0x3ffefa1bee615a27, 0x3fff50765b6e4540, 0x3fffa7c1819e90d8
))

const CR_EXP2F_B = NTuple{4, Float64}((
    1.0, 0x1.62e42fef4c4e7p-1,
    0x1.ebfd1b232f475p-3, 0x1.c6b19384ecd93p-5
))

const CR_EXP2F_C = NTuple{6, Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c58fp-3, 0x1.c6b08d702e0edp-5,
    0x1.3b2ab6fb92e5ep-7, 0x1.5d886e6d54203p-10, 0x1.430976b8ce6efp-13
))


function _exp2f_as_special(x::Float32)
    tu = reinterpret(UInt32, x)
    ux = tu << 1
    if ux >= UInt32(0xff) << 24
        # x is inf or nan
        if ux > UInt32(0xff) << 24
            return x + x  # NaN
        end
        ir = (Inf32, 0.0f0)
        return ir[(tu >> 31) + 1]  # +-Inf
    end
    if tu >= 0xc3150000  # -149.0f0
        z = Float64(x)
        y = 0x1p-149 + (z + 149) * 0x1p-150
        y = max(y, 0x1p-151)
        r = Float32(y)
        # if r == 0.0f0
        #     errno = ERANGE
        # end
        return r
    end
    r = Float32(0x1p127) * Float32(0x1p127)
    # if r > Float32(0x1.fffffep127)
    #     errno = ERANGE
    # end
    return r
end

"""
Correctly-rounded 2^x function for `Float32`.
"""
function cr_exp2f(x::Float32)::Float32
    tu = reinterpret(UInt32, x)

    if @unlikely((tu & UInt32(0xffff)) == 0)
        k = ((tu >> 23) & UInt32(0xff)) - 127
        if @unlikely(k >= 0 && k < 9 && (tu << (9 + k)) == 0)
            # NOTE: Arithmetic shift/signed shift
            msk = reinterpret(Int32, tu) >> 31
            m = Int32(((tu & 0x7fffff) | (Int32(1) << 23)) >> (23 - k))
            m = (m ⊻ msk) - msk + 127
            if m > 0 && m < 255
                tu = UInt32(m) << 23
                return reinterpret(Float32, tu)
            elseif m <= 0 && m > -23
                tu = UInt32(1) << (22 + m)
                return reinterpret(Float32, tu)
            end
        end
    end

    ux = tu << 1
    #            ux >= 128.0f0    || ux < 1.4901161f-8
    if @unlikely(ux >= 0x86000000 || ux < 0x65000000)
        if @likely(ux < 0x65000000)
            return 1.0f0 + x
        end
        # tu not in [0xc3000000, 0xc3150000) [-128.0f0, -149.0f0)
        if !(tu >= 0xc3000000 && tu < 0xc3150000)
            return _exp2f_as_special(x)
        end
    end

    offd = 0x1.8p46
    xd = Float64(x)
    h = xd - ((xd + offd) - offd)
    h2 = h * h
    uu = reinterpret(UInt32, x + Float32(0x1.8p17))
    svu = CR_EXP2F_TB[(uu & 0x3f) + 1]
    svu += UInt64(uu >> 6) << 52
    svf = reinterpret(Float64, svu)
    b = CR_EXP2F_B
    r = svf * ((b[1] + h * b[2]) + h2 * (b[3] + h * b[4]))
    eps = 0x1.3d8p-33
    ub = Float32(r)
    lb = Float32(r - r * eps)

    if @likely(ub != lb)
        if @unlikely(ux <= 0x79e7526e)  # ux <= 0.029743774f0
            if tu == 0x3b429d37  # 0.0029695758f0
                return Float32(0x1.00870ap+0) - Float32(0x1p-25)
            elseif tu == 0xbcf3a937  # -0.029743774f0
                return Float32(0x1.f58d62p-1) - Float32(0x1p-26)
            elseif tu == 0xb8d3d026  # -0.00010100035f0
                return Float32(0x1.fff6d2p-1) + Float32(0x1p-26)
            end
        end

        c = CR_EXP2F_C
        r = svf + (svf*h)*((c[1] + h*c[2]) + h2*((c[3] + h*c[4]) + h2*(c[5] + h*c[6])))
        ub = Float32(r)
    end

    return ub
end
