# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan/atanf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
Numerator coeffs for rminimax.

polynomials generated using rminimax (https://gitlab.inria.fr/sfilip/rminimax)
with the following command:

    ./ratapprox --function="atan(x)" \
        --dom=[0.000122070,1] \
        --num=[x,x^3,x^5,x^7,x^9,x^11,x^13] \
        --den=[1,x^2,x^4,x^6,x^8,x^10,x^12] \
        --output=atanf.sollya --log

(see output atanf.sollya)

The coefficient `cd[0]` was slightly reduced from the original value
`0x1.51eccde075d67p-2` to avoid an exceptional case for `|x| = 0x1.1ad646p-4`
and rounding to nearest.

See also [`CR_ATANF_CD`](@ref)
"""
const CR_ATANF_CN = NTuple{7, Float64}((
    0x1.51eccde075d67p-2, 0x1.a76bb5637f2f2p-1, 0x1.81e0eed20de88p-1,
    0x1.376c8ca67d11dp-2, 0x1.aec7b69202ac6p-5, 0x1.9561899acc73ep-9,
    0x1.bf9fa5b67e6p-16
))

"""
Denominator coeffs for rminimax.

See [`CR_ATANF_CN`](@ref)
"""
const CR_ATANF_CD = NTuple{7, Float64}((
    0x1.51eccde075d66p-2, 0x1.dfbdd7b392d28p-1, 0x1p+0,
    0x1.fd22bf0e89b54p-2, 0x1.d91ff8b576282p-4, 0x1.653ea99fc9bbp-7,
    0x1.1e7fcc202340ap-12
))


"""
    cr_atan(x::Float32)

Correctly-rounded arc-tangent of `Float32`.

# Examples
```jldoctest
julia> cr_atan(Inf32) / pi
0.5f0

julia> cr_atan(1.0f0) / pi
0.25f0

julia> cr_atan(0.0f0)
0.0f0

julia> cr_atan(-0.0f0)
-0.0f0

julia> cr_atan(-1.0f0) / pi
-0.25f0

julia> cr_atan(-Inf32) / pi
-0.5f0

julia> cr_atan(-NaN32)
NaN32
```

# Reference
- [core-math/src/binary32/atan/atanf.c](https://github.com/inkydragon/core-math/blob/2c08994e3cd967a63c4c1eed729353a1c3b9c798/src/binary32/atan/atanf.c)
"""
cr_atan(x::Float32) = cr_atanf(x)

function cr_atanf(x::Float32)::Float32
    # pi/2 constant
    pi2 = 0x1.921fb54442d18p+0
    @assert isequal(pi2, pi/2)

    tu = reinterpret(UInt32, x)
    e = Int((tu >> 23) & UInt32(0xff))
    ta = tu & 0x7fffffff
    if @unlikely(ta >= 0x4c700518)
        # |x| >= 6.2919776f7 (0x1.e00a3p+25)
        if (ta > 0x7f800000)
            # atan(NaN) = NaN
            return x + x
        end

        # pi/2 when |x| >= 6.2919776f7 (0x1.e00a3p+25)
        return copysign(pi2, Float64(x))
    end

    if @unlikely(e < (127 - 13))  # |x| < 0.00012207031f0 (0x1p-13)
        if @unlikely(e < (127 - 25))  # |x| < 2.9802322f-8 (0x1p-25)
            if (tu << UInt32(1)) == 0
                return x
            end
            res = fma(-x, abs(x), x)
            #=
                The Taylor expansion of atan(x) at x=0 is x - x^3/3 + o(x^3).
                For |x| > 2^-126 we have no underflow, whatever the rounding mode.
                For |x| < 2^-126, since |atan(x)| < |x|, we always have underflow.
                For |x| = 2^-126, we have underflow for rounding towards zero,
                i.e., when atan(x) rounds to nextbelow(2^-126).
                In summary, we have underflow whenever |x|<2^-126 or |res|<2^-126.
            =#
            # if (abs(x) < Float32(0x1p-126) || abs(res) < Float32(0x1p-126))
            #     errno = ERANGE  # underflow
            # end
            return res
        end

        return fma(Float32(-0x1.5555555555555p-2) * x, x * x, x)
    end

    #= now |x| >= 0.00012207031f0 (0x1p-13) =#
    # gt is non-zero for |x| >= 1
    gt = e >= 127
    z = Float64(x)
    if gt
        z = 1.0 / z
    end

    # minimax rational approximation for atan(x)
    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4
    # Numerator basis = x,x^3,x^5,x^7,x^9,x^11,x^13
    cn = CR_ATANF_CN
    cn0 = cn[1] + z2 * cn[2]
    cn2 = cn[3] + z2 * cn[4]
    cn4 = cn[5] + z2 * cn[6]
    cn6 = cn[7]
    cn0 += z4 * cn2
    cn4 += z4 * cn6
    cn0 += z8 * cn4
    cn0 *= z
    # Denominator basis = 1,x^2,x^4,x^6,x^8,x^10,x^12
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
    PI_OVER2_H = 0x1.9p0
    PI_OVER2_L = 0x1.0fdaa22168c23p-7
    #=
        now r approximates atan(1/x),we use atan(x) + atan(1/x) = sign(x)*pi/2,
        where PI_OVER2_H + PI_OVER2_L approximates pi/2.
        With sign(z)*L + (-r + sign(z)*H), it fails for x=0x1.98c252p+12 and
        rounding upward.
        With sign(z)*PI - r, where PI is a double approximation of pi to nearest,
        it fails for x=0x1.ddf9f6p+0 and rounding upward.
    =#
    r = (copysign(PI_OVER2_L, z) - r) + copysign(PI_OVER2_H, z)
    return Float32(r)
end
