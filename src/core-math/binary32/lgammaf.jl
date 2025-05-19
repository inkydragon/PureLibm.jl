# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/tgamma/tgammaf.c
# CORE-MATH project Copyright (c) 2023-2024 Alexei Sibidanov.


"""
    cr_lgamma(x::Float32)

Correctly-rounded logarithm of the absolute value of the gamma function for binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_lgamma(x::Float32) = cr_lgammaf(x)

function cr_lgammaf(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
