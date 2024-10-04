# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/acos/acosf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

function as_special(x::Float32)::Float32
    """Function to handle special cases
    """
    pih = Float32(0x1.921fb6p+1)
    pil = Float32(-0x1p-24)

    tu = reinterpret(UInt32, x)
    if tu == (0x000_007f << 23)
        return 0.0f0  # x = 1
    elseif tu == (0x000_0017f << 23)
        return pih + pil  # x = -1
    end

    ax = tu << UInt32(1)
    if ax > (0x000_00ff << 24)
        return x  # nan
    end

    # to raise FE_INVALID
    return 0.0f0 / 0.0f0
end

function poly12(z::Float64, c::Vector{Float64})::Float64
    """Polynomial evaluation for 12 coefficients
    """
    @assert 12 == length(c)

    z2 = z * z
    z4 = z2 * z2
    c0 = c[1] + z * c[2]
    c2 = c[3] + z * c[4]
    c4 = c[5] + z * c[6]
    c6 = c[7] + z * c[8]
    c8 = c[9] + z * c[10]
    c10 = c[11] + z * c[12]
    c0 += c2 * z2
    c4 += c6 * z2
    c8 += z2 * c10
    c0 += z4 * (c4 + z4 * c8)

    return c0
end


const CR_ACOSF_B = Vector{Float64}([
    0x1.fffffffd9ccb8p-1, 0x1.5555c94838007p-3, 0x1.32ded4b7c20fap-4, 0x1.8566df703309ep-5,
    -0x1.980c959bec9a3p-6, 0x1.56fbb04998344p-1, -0x1.403d8e4c49f52p+2, 0x1.b06c3e9f311eap+4,
    -0x1.9ea97c4e2c21fp+6, 0x1.200b8261cc61bp+8, -0x1.2274c2799a5c7p+9, 0x1.a558a59cc19d3p+9,
    -0x1.aca4b6a529ffp+9, 0x1.228744703f813p+9, -0x1.d7dbb0b322228p+7, 0x1.5c2018c0c0105p+5
])

const CR_ACOSF_C1 = Vector{Float64}([
    0x1.555555555529cp-3, 0x1.333333337e0ddp-4, 0x1.6db6db3b4465ep-5, 0x1.f1c72e13ac306p-6,
    0x1.6e89cebe06bc4p-6, 0x1.1c6dcf5289094p-6, 0x1.c6dbbcc7c6315p-7, 0x1.8f8dc2615e996p-7,
    0x1.a5833b7bf15e8p-8, 0x1.43f44ace1665cp-6, -0x1.0fb17df881c73p-6, 0x1.07520c026b2d6p-5
])

const CR_ACOSF_C2 = Vector{Float64}([
    0x1.6a09e667f3bcbp+0, 0x1.e2b7dddff2db9p-4, 0x1.b27247ab42dbcp-6, 0x1.02995cc4e0744p-7,
    0x1.5ffb0276ec8eap-9, 0x1.033885a928decp-10, 0x1.911f2be23f8c7p-12, 0x1.4c3c55d2437fdp-13,
    0x1.af477e1d7b461p-15, 0x1.abd6bdff67dcbp-15, -0x1.1717e86d0fa28p-16, 0x1.6ff526de46023p-16
])

function cr_acosf(x::Float32)::Float32
    """Correctly-rounded arc-cosine function for Float32.
    """
    pi2 = 0x1.921fb54442d18p+0  # Pi/2 constant
    o = [0.0, 0x1.921fb54442d18p+1]  # Table for accuracy

    xs = Float64(x)
    r = Float64(0.0)
    tu = reinterpret(UInt32, x)
    ax = tu << 1

    if ax >= (0x0000_007f << 24)
        return as_special(x)
    end

    # Case where input is within range
    if ax < 0x7ec29000
        z = xs
        z2 = z * z
        z4 = z2 * z2
        z8 = z4 * z4
        z16 = z8 * z8
        b = CR_ACOSF_B
        r = z * (
            ((b[1] + z2 * b[2]) + z4 * (b[3] + z2 * b[4])) +
            z8 * ((b[5] + z2 * b[6]) + z4 * (b[7] + z2 * b[8])) +
            z16 * (((b[9] + z2 * b[10]) + z4 * (b[11] + z2 * b[12])) +
                   z8 * ((b[13] + z2 * b[14]) + z4 * (b[15] + z2 * b[16])))
        )
        
        ub = Float32(0x1.921fb54574191p+0 - r)
        lb = Float32(0x1.921fb543118ap+0 - r)
        if ub == lb
            return Float32(ub)
        end
    end

    # Accurate path
    if ax < (0x0000_007e << 24)
        if tu == 0x3288_85a3
            return Float32(Float32(0x1.921fb6p+0) + 0x1p-25)
        elseif tu == 0x3982_6222
            return Float32(Float32(0x1.920f6ap+0) + 0x1p-25)
        end

        x2 = xs * xs
        r = (pi2 - xs) - (xs * x2) * poly12(x2, CR_ACOSF_C1)
    else
        bx = abs(xs)
        z = 1.0 - bx
        s = Base.Math.copysign(sqrt(z), xs)
        r = o[Int(tu >> 31) + 1] + s * poly12(z, CR_ACOSF_C2)
    end

    return Float32(r)
end

acos(x::Float32) = cr_acosf(x)
