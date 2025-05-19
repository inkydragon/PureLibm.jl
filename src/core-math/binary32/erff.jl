# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan2/atan2f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov and Paul Zimmermann.

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
