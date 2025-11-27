# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp10m1/exp10m1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov, Paul Zimmermann.

#! format: off
const CR_EXP10M1F_C = NTuple{6,Float64}([
    0x1.62e42fefa398bp-5, 0x1.ebfbdff84555ap-11, 0x1.c6b08d4ad86d3p-17,
    0x1.3b2ad1b1716a2p-23, 0x1.5d7472718ce9dp-30, 0x1.4a1d7f457ac56p-37,
])

"""
`tb[j] = 2^(j/16), j = 0..15;`

## `tb` generation

```julia
tb = [ @sprintf("%a",Float64( 2^(BigInt(j)/16)) ) for j in 0:15 ]
join(tb, ", ")
```
"""
const CR_EXP10M1F_TB = NTuple{16,Float64}([
    0x1p+0, 0x1.0b5586cf9890fp+0, 0x1.172b83c7d517bp+0, 0x1.2387a6e756238p+0,
    0x1.306fe0a31b715p+0, 0x1.3dea64c123422p+0, 0x1.4bfdad5362a27p+0, 0x1.5ab07dd485429p+0,
    # TODO: verify that  tb[end-5] ???==        0x1.8ace5422aa0dbp+0
    0x1.6a09e667f3bcdp+0, 0x1.7a11473eb0187p+0, 0x1.8ace5422aa0dap+0, 0x1.9c49182a3f09p+0,
    0x1.ae89f995ad3adp+0, 0x1.c199bdd85529cp+0, 0x1.d5818dcfba487p+0, 0x1.ea4afa2a490dap+0,
])

const CR_EXP10M1F_Q = NTuple{2,NTuple{2,Float32}}((
    (Float32(0x1.fffffep127), Float32(0x1.fffffep127)),
    (Float32(-1.0), Float32(0x1p-26)),
))

"""
    CR_EXP10M1F_ILN10H

high part of `iln10 = 16 / ln(10)`.
"""
const CR_EXP10M1F_ILN10H = 0x1.a934f09p+1 * 16
"""
    CR_EXP10M1F_ILN10L

low part of `iln10 = 16 / ln(10)`
"""
const CR_EXP10M1F_ILN10L = 0x1.e68dc57f2496p-29 * 16

# Small-range polynomial coefficient tables (cp) extracted
const CR_EXP10M1F_CP_4 = NTuple{4,Float64}([
    0x1.26bb1bbb55515p+1, 0x1.53524c73cea69p+1, 0x1.0470595038cc2p+1, 0x1.2bd7609fe1561p+0,
])

const CR_EXP10M1F_CP_5 = NTuple{5,Float64}([
    0x1.26bb1bbb55516p+1, 0x1.53524c73ce6dbp+1, 0x1.0470591de3024p+1, 0x1.2bd76b79060e6p+0,
    0x1.1429ffd3a963dp-1,
])

const CR_EXP10M1F_CP_6 = NTuple{6,Float64}([
    0x1.26bb1bbb55516p+1, 0x1.53524c73cea67p+1, 0x1.0470591dc2953p+1, 0x1.2bd760a004d64p+0,
    0x1.142a85da6f072p-1, 0x1.a7ed70725b00ep-3,
])

const CR_EXP10M1F_CP_7 = NTuple{7,Float64}([
    0x1.26bb1bbb55516p+1, 0x1.53524c73ceadep+1, 0x1.0470591de2bb4p+1, 0x1.2bd76099a9d33p+0,
    0x1.1429ffd829b0bp-1, 0x1.a7f2a6a0f7dc8p-3, 0x1.16e4dfbce0f56p-4,
])

const CR_EXP10M1F_CP_8 = NTuple{8,Float64}([
    0x1.26bb1bbb55515p+1, 0x1.53524c73cea6ap+1, 0x1.0470591de476p+1, 0x1.2bd7609fd4ee2p+0,
    0x1.1429ff70a9b48p-1, 0x1.a7ed71259ba5bp-3, 0x1.16f3004fb3ac1p-4, 0x1.4116b0388aa9fp-6,
])

const CR_EXP10M1F_CP_9 = NTuple{9,Float64}([
    0x1.26bb1bbb55515p+1, 0x1.53524c73cea42p+1, 0x1.0470591de2d1dp+1, 0x1.2bd760a010a53p+0,
    0x1.1429ffd16170cp-1, 0x1.a7ed6b2a0d97fp-3, 0x1.16e4e37fa51e4p-4, 0x1.4147fe4c1676fp-6,
    0x1.4897c4b3e329ap-8,
])
#! format: on

"""
    cr_exp10m1(x::Float32)

Correctly-rounded base-10 exponent function biased by 1 for `Float32`.

# Examples
```jldoctest
julia> PureLibm.cr_exp10m1.(Float32[0.0, 1, 2, 3])
4-element Vector{Float32}:
   0.0
   9.0
  99.0
 999.0

julia> PureLibm.cr_exp10m1.(Float32[38, 39, 40, Inf])
4-element Vector{Float32}:
  1.0f38
 Inf
 Inf
 Inf

julia> PureLibm.cr_exp10m1(-Inf32)
-1.0f0
```

# Reference
- [core-math/src/binary32/exp10m1/exp10m1f.c](https://github.com/inkydragon/core-math/blob/6616e78eb7083f63bdb3875204c39849cb2db7c8/src/binary32/exp10m1/exp10m1f.c)
"""
cr_exp10m1(x::Float32) = cr_exp10m1f(x)

function cr_exp10m1f(x::Float32)::Float32
    z = Float64(x)
    tu = reinterpret(UInt32, x)
    ax = tu & (typemax(UInt32) >> 1)

    if @unlikely(tu > 0xc0f0d2f1)
        # x < -7.5257497f0
        if ax > (UInt32(0xff) << 23)
            # exp10m1(NaN) = NaN
            return x + x
        end

        # for x=-Inf, don't raise the inexact exception
        if tu == 0xff800000
            return CR_EXP10M1F_Q[2][1]
        else
            return CR_EXP10M1F_Q[2][1] + CR_EXP10M1F_Q[2][2]
        end
    elseif @unlikely(ax > 0x421a209a)
        # |x| > 38.531837f0
        if ax >= (UInt32(0xff) << 23)
            # exp10m1(+Inf) = +Inf
            # exp10m1(NaN) = NaN
            return x + x
        end

        # errno = ERANGE  # overflow
        return CR_EXP10M1F_Q[1][1] + CR_EXP10M1F_Q[1][2]
    elseif @unlikely(ax < 0x3d89c604)
        # |x| < 0.1549/log(10) == 0.067272216f0
        z2 = z * z
        r = 0.0
        if @unlikely(ax < 0x3d1622fb)
            # |x| < 8.44e-2/log(10) == 0.036654454f0
            if @unlikely(ax < 0x3c8b76a3)
                # |x| < 3.92e-2/log(10) == 0.017024344f0
                if @unlikely(ax < 0x3bcced04)
                    # |x| < 1.44e-2/log(10) == 0.0062538404f0
                    if @unlikely(ax < 0x3acf33eb)
                        # |x| < 3.64e-3/log(10) == 0.001580832f0
                        if @unlikely(ax < 0x395a966b)
                            # |x| < 4.8e-4/log(10) == 0.00020846135f0
                            if @unlikely(ax < 0x36fe4a4b)
                                # |x| < 1.745e-5/log(10) == 7.5784387f-6
                                if @unlikely(ax < 0x32407f39)
                                    # |x| < 2.58e-8/log(10) == 1.1204798f-8
                                    if @unlikely(ax < 0x245e5bd9)
                                        # |x| <= 4.8216374f-17
                                        #=
                                            for |x| <= 0x1.bcb7bp-128, exp10m1(x) underflows,
                                            except for rounding away from zero
                                        =#
                                        # errno = ERANGE  # underflow
                                        r = 0x1.26bb1bbb55516p+1
                                    else
                                        if @unlikely(tu == 0x2c994b7b)
                                            # x = 4.3569016f-12
                                            return Float32(0x1.60f974p-37) -
                                                   Float32(0x1p-90)
                                        end

                                        r = 0x1.26bb1bbb55516p+1 + z * 0x1.53524c73cea69p+1
                                    end
                                else
                                    if @unlikely(tu == 0xb6fa215b)
                                        # x = -7.4544637f-6
                                        return -Float32(0x1.1ff87ep-16) + Float32(0x1p-68)
                                    end

                                    r =
                                        0x1.26bb1bbb55516p+1 +
                                        z *
                                        (0x1.53524c73ea62fp+1 + z * 0x1.0470591de2c75p+1)
                                end
                            else
                                c = CR_EXP10M1F_CP_4
                                r = (c[1] + z * c[2]) + z2 * (c[3] + z * c[4])
                            end
                        else
                            c = CR_EXP10M1F_CP_5
                            r = (c[1] + z * c[2]) + z2 * (c[3] + z * (c[4] + z * c[5]))
                        end
                    else
                        c = CR_EXP10M1F_CP_6
                        r =
                            (c[1] + z * c[2]) +
                            z2 * ((c[3] + z * c[4]) + z2 * (c[5] + z * c[6]))
                    end
                else
                    c = CR_EXP10M1F_CP_7
                    r =
                        (c[1] + z * c[2]) +
                        z2 * ((c[3] + z * c[4]) + z2 * (c[5] + z * (c[6] + z * c[7])))
                end
            else
                c = CR_EXP10M1F_CP_8
                r =
                    ((c[1] + z * c[2]) + z2 * (c[3] + z * c[4])) +
                    (z2 * z2) * ((c[5] + z * c[6]) + z2 * (c[7] + z * c[8]))
            end
        else
            c = CR_EXP10M1F_CP_9
            r =
                ((c[1] + z * c[2]) + z2 * (c[3] + z * c[4])) +
                (z2 * z2) * ((c[5] + z * c[6]) + z2 * (c[7] + z * (c[8] + z * c[9])))
        end
        r *= z

        return Float32(r)
    else
        # -7.5257497f0 < x < -0.1549/log(10)
        # or  0.067272216f0 == 0.1549/log(10) < x < 38.531837f0
        if @unlikely((tu << 11) == 0)
            k = Int((tu >> 21) - 0x000001fc)
            if k <= 0x0000000b
                if k == 0
                    return Float32(10.0) - Float32(1.0)
                elseif k == 4
                    return Float32(100.0) - Float32(1.0)
                elseif k == 6
                    return Float32(1000.0) - Float32(1.0)
                elseif k == 8
                    return Float32(10000.0) - Float32(1.0)
                elseif k == 9
                    return Float32(100000.0) - Float32(1.0)
                elseif k == 10
                    return Float32(1000000.0) - Float32(1.0)
                elseif k == 11
                    return Float32(10000000.0) - Float32(1.0)
                end
                # NOTE: eps(1.0f7) == 1;  eps(1.0f8) == 8
            end
        end

        a = CR_EXP10M1F_ILN10H * z
        ia = floor(a)
        h = (a - ia) + CR_EXP10M1F_ILN10L * z
        i64 = Int64(ia)
        j = Int(i64 & 0x0f)
        e = Int64(i64 - j)
        e >>= 4

        s = CR_EXP10M1F_TB[j+1]
        su_bits = (UInt64(e + 0x3ff) << 52)
        sf = reinterpret(Float64, su_bits)
        s *= sf

        h2 = h * h
        c = CR_EXP10M1F_C
        c0 = c[1] + h * c[2]
        c2 = c[3] + h * c[4]
        c4 = c[5] + h * c[6]
        c0 += h2 * (c2 + h2 * c4)
        w = s * h

        return Float32((s - 1.0) + w * c0)
    end
end
