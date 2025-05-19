# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/exp2m1/exp2m1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

"""
    cr_exp2m1(x::Float32)

Correctly-rounded base-2 exponent function biased by 1 for binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_exp2m1(x::Float32) = cr_exp2m1f(x)

function cr_exp2m1f(x::Float32)
    exp2(x) - 1.0f0
end
