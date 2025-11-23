# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atanpi/atanpif.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

const CR_ATANPIF_CN = NTuple{6,Float64}((
    0x1.45f306dc9c882p-2,
    0x1.733b561bc23d5p-1,
    0x1.28d9805bdfbf2p-1,
    0x1.8c3ba966ae287p-3,
    0x1.94a7f81ee634bp-6,
    0x1.a6bbf6127a6dfp-11,
))

const CR_ATANPIF_CD = NTuple{7,Float64}((
    0x1p+0,
    0x1.4e3b3ecc2518fp+1,
    0x1.3ef4a360ff063p+1,
    0x1.0f1dc55bad551p+0,
    0x1.8da0fecc018a4p-3,
    0x1.8fa87803776bfp-7,
    0x1.dadf2ca0acb43p-14,
))


"""
    cr_atanpi(x::Float32)

Correctly-rounded half-revolution arc-tangent of `Float32` value.
This function computes `atan(x)/π`.

# Examples
```jldoctest
julia> PureLibm.cr_atanpi.((0.0f0, -0.0f0))
(0.0f0, -0.0f0)

julia> PureLibm.cr_atanpi.((0.5f0, -0.5f0))
(0.14758362f0, -0.14758362f0)

julia> PureLibm.cr_atanpi(-0.5f0) == -PureLibm.cr_atanpi(0.5f0)
true

julia> PureLibm.cr_atanpi.((1.0f0, -1.0f0))
(0.25f0, -0.25f0)
```

# Reference
- [core-math/src/binary32/atanpi/atanpif.c](https://github.com/inkydragon/core-math/blob/9f7bf82f5abdf032f3a4733e97ee4a8069bdbed6/src/binary32/atanpi/atanpif.c)
"""
cr_atanpi(x::Float32) = cr_atanpif(x)

function cr_atanpif(x::Float32)
    tu = reinterpret(UInt32, x)
    e = (tu >> 23) & UInt32(0xff)
    gt = (e >= 127)
    if @unlikely(e > (127 + 24))
        # |x| >= 2^25
        f = copysign(0.5f0, x)
        if @unlikely(e == 0xff)
            if (tu << 9) != 0
                return x + x  # nan
            end
            return f  # inf
        end
        # Warning: 0x1.45f306p-2f / x underflows for |x| >= 0x1.45f306p+124
        if abs(x) >= Float32(0x1.45f306p+124)
            return f - copysign(Float32(0x1p-26), x)
        else
            return f - Float32(0x1.45f306p-2) / x
        end
    end

    z = Float64(x)
    if @unlikely(e < (127 - 13))
        # |x| < 2^-13
        sx = z * 0x1.45f306dc9c883p-2
        if @unlikely(e < (127 - 25))
            # |x| < 2^-25
            #= For rounding towards zero, the largest positive number for which there
                is underflow is 0x1.921fb4p-125.
                For rounding to nearest, it is 0x1.921fb4p-125 too (although the result
                is 0x1p-126).
                For rounding upwards, it is 0x1.921fb2p-125.
            =#
            # THRESHOLD = 0x1.fffffe632357dp-127
            # C0 = 0x1.45f306dc9c882p-2
            # if (x != 0.0f0
            #         && (abs(x) <= 0x1.921fb2p-125
            #             || (abs(x) == 0x1.921fb4p-125
            #                 && abs(z * C0) <= THRESHOLD)))
            #     errno = ERANGE  # underflow
            # end
            return Float32(sx)
        end
        return Float32(sx - (0x1.5555555555555p-2 * sx) * (z * z))
    end

    ax = tu & (~UInt32(0) >> 1)
    if @unlikely(ax == 0x3fa267dd)
        # 1.2687947f0 (0x1.44cfbap+0)
        return copysign(Float32(0x1.267004p-2), x) - copysign(Float32(0x1p-55), x)
    end
    if @unlikely(ax == 0x3f693531)
        # 0.9109679f0 (0x1.d26a62p-1)
        return copysign(Float32(0x1.e1a662p-3), x) + copysign(Float32(0x1p-28), x)
    end
    if @unlikely(ax == 0x3f800000)
        # 1.0f0 (0x1p+0)
        return copysign(Float32(0x1p-2), x)
    end

    if gt
        z = 1 / z
    end

    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4
    cn = CR_ATANPIF_CN
    cn0 = cn[1] + z2 * cn[2]
    cn2 = cn[3] + z2 * cn[4]
    cn4 = cn[5] + z2 * cn[6]
    cn0 += z4 * cn2
    cn0 += z8 * cn4
    cn0 *= z

    cd = CR_ATANPIF_CD
    cd0 = cd[1] + z2 * cd[2]
    cd2 = cd[3] + z2 * cd[4]
    cd4 = cd[5] + z2 * cd[6]
    cd6 = cd[7]
    cd0 += z4 * cd2
    cd4 += z4 * cd6
    cd0 += z8 * cd4

    r = cn0 / cd0
    if gt
        r = copysign(0.5, z) - r
    end
    return Float32(r)
end
