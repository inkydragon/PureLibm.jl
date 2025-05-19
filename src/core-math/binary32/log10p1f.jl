# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log10p1/log10p1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

"""
    cr_log10p1(x::Float32)

Correctly-rounded log2(1+x) function for binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_log10p1(x::Float32) = cr_log10p1f(x)

function cr_log10p1f(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
