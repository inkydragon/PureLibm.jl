# SPDX-License-Identifier: MIT OR Apache-2.0
# ref: IEEE 754

"""
    Name    Hex         hex: %a     base2   base10(not exact)
    +0      0x00000000  0x0p+0      0       0.000E+00
"""
const F32_POS_ZERO = UInt32(0x0)

"""
    Name            Hex         hex: %a     base2   base10(not exact)
    Min Subnormal   0x00000001  0x1p-149    2^-149  1.401E-45
"""
const F32_MIN_SUBNORMAL = UInt32(0x00000001)

"""
    Name            Hex         hex: %a         base2               base10(not exact)
    Max Subnormal   0x007fffff  0x1.fffffcp-127 (1-2^-23)×2^-126    1.175E-38
"""
const F32_MAX_SUBNORMAL = UInt32(0x007fffff)

"""
    Name        Hex         hex: %a     base2   base10(not exact)
    Min Normal  0x00800000  0x1p-126    2^-126  1.175E-38
"""
const F32_MIN_NORMAL = UInt32(0x00800000)

"""
    Name        Hex         hex: %a             base2               base10(not exact)
    Max Normal  0x7f7fffff  0x1.fffffep+127     (1-2^-24)×2^128     3.403E+38
"""
const F32_MAX_NORMAL = UInt32(0x7f7fffff)
const F32_MAX_FINITE = F32_MAX_NORMAL

"""
    Name        Hex         hex: %a
    Inf         0x7f800000  inf
"""
const F32_POS_INF = UInt32(0x7f800000)

"""
    Name        Hex         hex: %a
    NaN (+min)  0x7f800001  nan
"""
const F32_MIN_NAN = UInt32(0x7f800001)

"""
    Name        Hex         hex: %a
    NaN (+max)  0x7fffffff  nan
"""
const F32_MAX_NAN = UInt32(0x7fffffff)
