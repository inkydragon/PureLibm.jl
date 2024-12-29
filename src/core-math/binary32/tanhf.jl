# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/tanh/tanhf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
Numerator coeffs for rminimax.

polynomials generated using rminimax (https://gitlab.inria.fr/sfilip/rminimax)
with the following command:

    ./ratapprox --function="tanh(x)" \
        --dom=[0x1p-12,9.?????] \
        --num=[x,x^3,x^5,x^7,x^9,x^11,x^13,x^15] \
        --den=[1,x^2,x^4,x^6,x^8,x^10,x^12,x^14] \
        --log --output=tanh.sollya

TODO: find out --dom range

See also [`CR_TANHF_CD`](@ref)
"""
const CR_TANHF_CN = NTuple{8, Float64}((
    0x1p+0, 0x1.30877b8b72d33p-3,
    0x1.694aa09ae9e5ep-8, 0x1.4101377abb729p-14,
    0x1.e0392b1db0018p-22, 0x1.2533756e546f7p-30,
    0x1.d62e5abe6ae8ap-41, 0x1.b06be534182dep-54
))

"""
Denominator coeffs for rminimax.

See [`CR_TANHF_CN`](@ref)
"""
const CR_TANHF_CD = NTuple{8, Float64}((
    0x1p+0, 0x1.ed99131b0ebeap-2,
    0x1.0d27ed6c95a69p-5, 0x1.7cbdaca0e9fccp-11,
    0x1.b4e60b892578ep-18, 0x1.a6f707c5c71abp-26,
    0x1.35a8b6e2cd94cp-35, 0x1.ca8230677aa01p-47
))


"""
Correctly-rounded hyperbolic tangent function for `Float32`.
"""
function cr_tanhf(x::Float32)::Float32
    ux = reinterpret(UInt32, x)
    e = (ux >> 23) & 0xff

    # special input
    if @unlikely(e == 0xff)
        if (ux << 9) != 0
            # tanh(NaN) = NaN
            return x + x
        end
        # tanh(+-Inf) = +-1.0
        ir = (1.0f0, -1.0f0)
        return ir[(ux >> 31) + 1]
    end

    if @unlikely(e < 115)  # |x| < 0.00024414062f0 (0x1p-12)
        if @unlikely(e < 102)  # |x| < 2.9802322f-8 (0x1p-25)
            if @unlikely((ux << 1) == 0)
                # tanh(+-0) = +-0.0
                return x
            end

            return fma(-x, abs(x), x)
        end

        x2 = x * x
        return fma(x, Float32(-0x1.555556p-2) * x2, x)
    end

    if (ux << 1) > (0x41102cb3 << 1)  # |x| > 9.010913f0
        return copysign(1.0f0, x) - copysign(Float32(0x1p-25), x)
    end

    # minimax rational approximation for tanh(x)
    z = Float64(x)
    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4
    # Numerator basis = x,x^3,x^5,x^7,x^9,x^11,x^13,x^15
    cn = CR_TANHF_CN
    n0 = cn[1] + z2 * cn[2]
    n2 = cn[3] + z2 * cn[4]
    n4 = cn[5] + z2 * cn[6]
    n6 = cn[7] + z2 * cn[8]
    n0 += z4 * n2
    n4 += z4 * n6
    n0 += z8 * n4
    # Denominator basis = 1,x^2,x^4,x^6,x^8,x^10,x^12,x^14
    cd = CR_TANHF_CD
    d0 = cd[1] + z2 * cd[2]
    d2 = cd[3] + z2 * cd[4]
    d4 = cd[5] + z2 * cd[6]
    d6 = cd[7] + z2 * cd[8]
    d0 += z4 * d2
    d4 += z4 * d6
    d0 += z8 * d4
    r = z * n0 / d0

    return r
end
