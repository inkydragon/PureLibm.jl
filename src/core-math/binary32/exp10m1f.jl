# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp10/exp10f.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

"""
    cr_exp10m1(x::Float32)

Correctly-rounded base-10 exponent function biased by 1 for binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_exp10m1(x::Float32) = cr_exp10m1f(x)

function cr_exp10m1f(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
