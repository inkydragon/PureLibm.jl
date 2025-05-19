# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/erfc/erfcf.c
# CORE-MATH project Copyright (c) 2023-2025 Alexei Sibidanov.

"""
    cr_erfc(x::Float32)

Correctly-rounded complementary error function for the binary32 value.

!!! warning
    This function is not implemented yet
"""
cr_erfc(x::Float32) = cr_erfcf(x)

function cr_erfcf(x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
