# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/pow/powf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov and Paul Zimmermann.

"""
    cr_pow(x::Float32, y::Float32)

Correctly-rounded power function for binary32 values.

!!! warning
    This function is not implemented yet
"""
cr_pow(x::Float32, y::Float32) = cr_powf(x, y)

function cr_powf(x::Float32, y::Float32)
    x^y
end
