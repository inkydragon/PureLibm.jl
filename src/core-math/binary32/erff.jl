# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/erf/erff.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

"""
    cr_erf(x::Float32)

Correctly-rounded error function for binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_erf(x::Float32) = cr_erff(x)

function cr_erff(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
