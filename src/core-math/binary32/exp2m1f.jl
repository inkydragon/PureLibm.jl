# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp2m1/exp2m1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

#! format: off
const CR_EXP2M1F_Q = NTuple{3,NTuple{2,Float32}}((
    (Float32(0x1.fffffep127), Float32(0x1.fffffep127)),
    (Float32(0x1.fffffep127), Float32(0x1p+103)),
    (Float32(-1.0), Float32(0x1p-26)),
))

const CR_EXP2M1F_C_3 = NTuple{3,Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff8548fdp-3, 0x1.c6b08d704a06dp-5,
))

const CR_EXP2M1F_C_4 = NTuple{4,Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c58fp-3, 0x1.c6b08dc82b347p-5, 0x1.3b2ab6fbad172p-7,
))

const CR_EXP2M1F_C_5 = NTuple{5,Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c068p-3, 0x1.c6b08d704a6dcp-5, 0x1.3b2ac262c3eedp-7,
    0x1.5d87fe7af779ap-10,
))

const CR_EXP2M1F_C_6 = NTuple{6,Float64}((
    0x1.62e42fefa39fp-1, 0x1.ebfbdff82c58dp-3, 0x1.c6b08d7011d13p-5, 0x1.3b2ab6fbd267dp-7,
    0x1.5d88a81cea49ep-10, 0x1.430912ea9b963p-13,
))

const CR_EXP2M1F_C_7 = NTuple{7,Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c639p-3, 0x1.c6b08d7049f1cp-5, 0x1.3b2ab6f5243bdp-7,
    0x1.5d87fe80a9e6cp-10, 0x1.430d0b9257fa8p-13, 0x1.ffcbfc4cf0952p-17,
))

const CR_EXP2M1F_C_8 = NTuple{8,Float64}((
    0x1.62e42fefa39efp-1, 0x1.ebfbdff82c591p-3, 0x1.c6b08d704cf6bp-5, 0x1.3b2ab6fba00cep-7,
    0x1.5d87fdfdaadb4p-10, 0x1.4309137333066p-13, 0x1.ffe5e90daf7ddp-17, 0x1.62c0220eed731p-20,
))

const CR_EXP2M1F_C = NTuple{6,Float64}((
    0x1.62e42fefa398bp-5, 0x1.ebfbdff84555ap-11, 0x1.c6b08d4ad86d3p-17,
    0x1.3b2ad1b1716a2p-23, 0x1.5d7472718ce9dp-30, 0x1.4a1d7f457ac56p-37,
))

const CR_EXP2M1F_TB = NTuple{16,Float64}((
    0x1p+0, 0x1.0b5586cf9890fp+0, 0x1.172b83c7d517bp+0, 0x1.2387a6e756238p+0,
    0x1.306fe0a31b715p+0, 0x1.3dea64c123422p+0, 0x1.4bfdad5362a27p+0, 0x1.5ab07dd485429p+0,
    0x1.6a09e667f3bcdp+0, 0x1.7a11473eb0187p+0, 0x1.8ace5422aa0dap+0, 0x1.9c49182a3f09p+0,
    0x1.ae89f995ad3adp+0, 0x1.c199bdd85529cp+0, 0x1.d5818dcfba487p+0, 0x1.ea4afa2a490dap+0,
))
#! format: on

"""
    cr_exp2m1(x::Float32)

Correctly-rounded base-2 exponent function biased by 1 for `Float32`.

# Reference
- [core-math/src/binary32/exp2m1/exp2m1f.c](https://github.com/inkydragon/core-math/blob/03c15350fdcc286625bc5fe9b57e47a2275af293/src/binary32/exp2m1/exp2m1f.c)
"""
cr_exp2m1(x::Float32) = cr_exp2m1f(x)

function cr_exp2m1f(x::Float32)::Float32
    tu = reinterpret(UInt32, x)
    z = Float64(x)
    ux = tu
    ax = ux & 0x7fffffff

    if @unlikely(ux >= 0xc1c80000)
        # x <= -25
        if ax > (UInt32(0xff) << 23)
            # nan
            return x + x
        end

        # avoid spurious inexact exception for -Inf
        if ux == 0xff800000
            return CR_EXP2M1F_Q[3][1]
        else
            return CR_EXP2M1F_Q[3][1] + CR_EXP2M1F_Q[3][2]
        end
    elseif @unlikely(ax >= 0x43000000)
        # |x| >= 128
        if ax > (UInt32(0xff) << 23)
            # nan
            return x + x
        end

        # avoid spurious inexact exception for +Inf
        if ux == 0x7f800000
            return x
        end

        # for x=128 and rounding downward or to zero, there is no overflow
        special =
            (x == Float32(128.0)) &&
            (Float32(CR_EXP2M1F_Q[2][1] + CR_EXP2M1F_Q[2][2]) == CR_EXP2M1F_Q[2][1])
        q_idx = special ? 2 : 1
        return Float32(CR_EXP2M1F_Q[q_idx][1] + CR_EXP2M1F_Q[q_idx][2])
    elseif @unlikely(ax < 0x3df95f1f)
        # |x| < 8.44e-2/log(2)
        z2 = z * z
        r = 0.0
        if @unlikely(ax < 0x3d67a4cc)
            # |x| < 3.92e-2/log(2)
            if @unlikely(ax < 0x3caa2fee)
                # |x| < 1.44e-2/log(2)
                if @unlikely(ax < 0x3bac1405)
                    # |x| < 3.64e-3/log(2)
                    if @unlikely(ax < 0x37d32ef6)
                        # |x| < 4.8e-4/log(2)
                        if @unlikely(ax < 0x331fdd82)
                            # |x| < 1.745e-5/log(2)
                            if @unlikely(ax < 0x2538aa3b)
                                # |x| < 2.58e-8/log(2)
                                #= exp2m1(x) underflows:
                                    for |x| <= 0x1.715476p-126 for rounding toward zero
                                    for |x| <= 0x1.715474p-126 for rounding to nearest/away
                                =#
                                # errno = ERANGE  # underflow
                                r = 0x1.62e42fefa39efp-1
                            else
                                r = 0x1.62e42fefa39fp-1 + z * 0x1.ebfbdff82c58fp-3
                            end
                        else
                            if @unlikely(ux == 0xb3d85005)
                                return Float32(-0x1.2bdf76p-24 - 0x1.8p-77)
                            end
                            if @unlikely(ux == 0x3338428d)
                                return Float32(0x1.fee08ap-26 + 0x1p-80)
                            end

                            c = CR_EXP2M1F_C_3
                            r = c[1] + z * (c[2] + z * c[3])
                        end
                    else
                        if @unlikely(ux == 0x388bca4f)
                            return Float32(0x1.839702p-15 - 0x1.8p-68)
                        end

                        c = CR_EXP2M1F_C_4
                        r = (c[1] + z * c[2]) + z2 * (c[3] + z * c[4])
                    end
                else
                    c = CR_EXP2M1F_C_5
                    r = (c[1] + z * c[2]) + z2 * (c[3] + z * (c[4] + z * c[5]))
                end
            else
                c = CR_EXP2M1F_C_6
                r = (c[1] + z * c[2]) + z2 * ((c[3] + z * c[4]) + z2 * (c[5] + z * c[6]))
            end
        else
            c = CR_EXP2M1F_C_7
            r =
                (c[1] + z * c[2]) +
                z2 * ((c[3] + z * c[4]) + z2 * (c[5] + z * (c[6] + z * c[7])))
        end
        r *= z
        return Float32(r)
    else
        # general range

        a = 16.0 * z
        ia = floor(a)
        h = a - ia
        i = Int64(ia)
        j = i & 0x0f
        e = (i - j) >> 4

        tb = CR_EXP2M1F_TB
        s = tb[Int(j)+1]
        su = reinterpret(Float64, (UInt64(e + 1023) << 52))
        s *= su

        c = CR_EXP2M1F_C
        c0 = c[1] + h * c[2]
        c2 = c[3] + h * c[4]
        c4 = c[5] + h * c[6]
        c0 += (h * h) * (c2 + (h * h) * c4)
        w = s * h

        return Float32((s - 1.0) + w * c0)
    end
end
