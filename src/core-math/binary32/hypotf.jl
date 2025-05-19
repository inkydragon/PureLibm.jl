# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/hypot/hypotf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

"""
    cr_hypot(x::Float32, y::Float32)

Correctly-rounded Euclidean distance function (hypot) for binary32 values.

!!! warning
    This function is not implemented yet
"""
cr_hypot(x::Float32, y::Float32) = cr_hypotf(x, y)

function cr_hypotf(x::Float32, y::Float32)
    hypot(x, y)
end
