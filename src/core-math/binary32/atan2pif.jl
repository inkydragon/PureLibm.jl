# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan2pi/atan2pif.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

"""
    cr_atan2pi(y::Float32, x::Float32)

Correctly-rounded half revolution arctangent function of two `Float32` values.

!!! warning
    This function is not implemented yet
"""
cr_atan2pi(y::Float32, x::Float32) = cr_atan2pif(y, x)

function cr_atan2pif(y::Float32, x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
