# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/asin/asinf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

"""
    cr_asin(x::Float32)

Correctly-rounded sine of `Float32` value for angles in half-revolutions.
"""
cr_asin(x::Float32) = cr_asinf(x)

function cr_asinf(x::Float32)
    return Float32(asin(x) / pi)
end
