# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/sqrt/sqrtf.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

"""
    cr_sqrt(x::Float32)

Correctly-rounded reciprocal square root of binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_sqrt(x::Float32) = cr_sqrtf(x)

function cr_sqrtf(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
