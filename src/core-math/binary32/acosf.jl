# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/acos/acosf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

const CR_ACOSF_B = NTuple{16, Float64}((
    0x1.fffffffd9ccb8p-1, 0x1.5555c94838007p-3, 0x1.32ded4b7c20fap-4, 0x1.8566df703309ep-5,
    -0x1.980c959bec9a3p-6, 0x1.56fbb04998344p-1, -0x1.403d8e4c49f52p+2, 0x1.b06c3e9f311eap+4,
    -0x1.9ea97c4e2c21fp+6, 0x1.200b8261cc61bp+8, -0x1.2274c2799a5c7p+9, 0x1.a558a59cc19d3p+9,
    -0x1.aca4b6a529ffp+9, 0x1.228744703f813p+9, -0x1.d7dbb0b322228p+7, 0x1.5c2018c0c0105p+5
))

const CR_ACOSF_C1 = NTuple{12, Float64}((
    0x1.555555555529cp-3, 0x1.333333337e0ddp-4, 0x1.6db6db3b4465ep-5, 0x1.f1c72e13ac306p-6,
    0x1.6e89cebe06bc4p-6, 0x1.1c6dcf5289094p-6, 0x1.c6dbbcc7c6315p-7, 0x1.8f8dc2615e996p-7,
    0x1.a5833b7bf15e8p-8, 0x1.43f44ace1665cp-6, -0x1.0fb17df881c73p-6, 0x1.07520c026b2d6p-5
))

const CR_ACOSF_C2 = NTuple{12, Float64}((
    0x1.6a09e667f3bcbp+0, 0x1.e2b7dddff2db9p-4, 0x1.b27247ab42dbcp-6, 0x1.02995cc4e0744p-7,
    0x1.5ffb0276ec8eap-9, 0x1.033885a928decp-10, 0x1.911f2be23f8c7p-12, 0x1.4c3c55d2437fdp-13,
    0x1.af477e1d7b461p-15, 0x1.abd6bdff67dcbp-15, -0x1.1717e86d0fa28p-16, 0x1.6ff526de46023p-16
))


"""
Special cases for `acosf` when `|x| >= 1`
"""
function _acosf_as_special(x::Float32)::Float32
    pih = Float32(0x1.921fb6p+1)
    pil = Float32(-0x1p-24)

    tu = reinterpret(UInt32, x)
    if tu == (0x000_007f << 23)
        # acos(1) = 0.0
        return 0.0f0
    elseif tu == (0x000_0017f << 23)
        # acos(-1) = pi
        return pih + pil
    end

    ax = tu << UInt32(1)
    if ax > (0x000_00ff << 24)
        # acos(NaN) = NaN
        return x + x
    end

    # acos(+-Inf) = NaN
    # to raise FE_INVALID
    return 0.0f0 / 0.0f0
end

"""
Correctly-rounded arc-cosine function for `Float32`.

## Reference
- https://gitlab.inria.fr/core-math/core-math/-/blob/f786e13fb0595adee545d7b29931d283f658ba0a/src/binary32/acos/acosf.c
"""
function cr_acosf(x::Float32)::Float32
    # pi/2 constant
    pi2 = 0x1.921fb54442d18p+0
    @assert isequal(pi2, pi/2)

    xs = Float64(x)
    r = Float64(0.0)
    tu = reinterpret(UInt32, x)
    ax = tu << UInt32(1)

    if @unlikely(ax >= (0x0000_007f << 24))
        # |x| >= 1.0
        return _acosf_as_special(x)
    end

    if @likely(ax < 0x7ec2a1dc)
        # |x| < 0.88014114f0 (0x1.c2a1dcp-1)
        # avoid spurious underflow
        if @unlikely(ax < 0x40000000)
            # |x| < 1.0842022f-19 (2^-63)
            #= GCC <= 11 wrongly assumes the rounding is to nearest and
                performs a constant folding here:
                https://gcc.gnu.org/bugzilla/show_bug.cgi?id=57245
            =#
            return Float32(pi2)
        end

        z = xs
        r = z * poly_x2_c16(z, CR_ACOSF_B)

        ub = Float32(0x1.921fb54574191p+0 - r)
        lb = Float32(0x1.921fb543118ap+0 - r)
        if ub == lb
            return ub
        end
    end

    # Accurate path
    if ax < (0x0000_007e << 24)
        # |x| < 0.5
        if tu == 0x328885a3  # 1.5893255f-8
            return Float32(0x1.921fb6p+0) + Float32(0x1p-25)
        elseif tu == 0x39826222  # 0.00024868647f0
            return Float32(0x1.920f6ap+0) + Float32(0x1p-25)
        end

        x2 = xs * xs
        r = (pi2 - xs) - (xs * x2) * poly12(x2, CR_ACOSF_C1)
    else
        # 0.5 <= |x| < 1.0
        bx = abs(xs)
        z = 1.0 - bx
        s = copysign(sqrt(z), xs)
        o = (0.0, 0x1.921fb54442d18p+1)
        r = o[(tu >> 31) + 1] + s * poly12(z, CR_ACOSF_C2)
    end

    return Float32(r)
end
