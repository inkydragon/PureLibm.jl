# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/acos/acosf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

# polynomials generated using rminimax

"""
polynomials generated using rminimax (https://gitlab.inria.fr/sfilip/rminimax)
with the following command:

    ./ratapprox --function="atan(x)" --dom=[0.000122070,1] --num=[x,x^3,x^5,x^7,x^9,x^11,x^13] --den=[1,x^2,x^4,x^6,x^8,x^10,x^12] --output=atanf.sollya --log

(see output atanf.sollya)

The coefficient cd[0] was slightly reduced from the original value
0x1.51eccde075d67p-2 to avoid an exceptional case for |x| = 0x1.1ad646p-4
and rounding to nearest.
"""
const CR_ATANF_CN = Vector{Float64}([
    0x1.51eccde075d67p-2, 0x1.a76bb5637f2f2p-1, 0x1.81e0eed20de88p-1,
    0x1.376c8ca67d11dp-2, 0x1.aec7b69202ac6p-5, 0x1.9561899acc73ep-9,
    0x1.bf9fa5b67e6p-16
])

const CR_ATANF_CD = Vector{Float64}([
    0x1.51eccde075d66p-2, 0x1.dfbdd7b392d28p-1, 0x1p+0,
    0x1.fd22bf0e89b54p-2, 0x1.d91ff8b576282p-4, 0x1.653ea99fc9bbp-7,
    0x1.1e7fcc202340ap-12
])


function cr_atanf(x::Float32)::Float32
    """Correctly-rounded arc-tangent of Float32.
    """
    pi2 = 0x1.921fb54442d18p+0

    tu = reinterpret(UInt32, x)
    e = Int((tu >> 23) & UInt32(0xff))
    gt = e >= 127
    if e == 0xff
        if (tu << UInt32(9)) != 0
            return x  # nan
        end

        return copysign(pi2, Float64(x))  # inf
    end

    if e < (127 - 13)
        if e < (127 - 25)
            if (tu << UInt32(1)) == 0
                return x
            end

            return fma(-x, abs(x), x)
        end

        return fma(Float32(-0x1.5555555555555p-2) * x, x * x, x)
    end

    # now |x| >= 0x1p-13
    z = Float64(x)
    if gt
        # gt is non-zero for |x| >= 1
        z = 1.0 / z
    end
    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4

    # polynomials generated using rminimax
    cn = CR_ATANF_CN
    cn0 = cn[1] + z2 * cn[2]
    cn2 = cn[3] + z2 * cn[4]
    cn4 = cn[5] + z2 * cn[6]
    cn6 = cn[7]
    cn0 += z4 * cn2
    cn4 += z4 * cn6
    cn0 += z8 * cn4
    cn0 *= z
    
    cd = CR_ATANF_CD
    cd0 = cd[1] + z2 * cd[2]
    cd2 = cd[3] + z2 * cd[4]
    cd4 = cd[5] + z2 * cd[6]
    cd6 = cd[7]
    cd0 += z4 * cd2
    cd4 += z4 * cd6
    cd0 += z8 * cd4

    r = cn0 / cd0
    if !gt
        # for |x| < 1, (float) r is correctly rounded
        return Float32(r)  
    end

    # now |x| >= 1
    r = copysign(0x1.0fdaa22168c23p-7, z) - r + copysign(0x1.9p0, z)
    return Float32(r)
end

atan(x::Float32) = cr_atanf(x)
