# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/cbrt/cbrtf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

"""
    cr_cbrt(x::Float32)

Correctly-rounded cubic root of `Float32` value.
"""
cr_cbrt(x::Float32) = cr_cbrtf(x)

function cr_cbrtf(x::Float32)
    cbrt(x)
end
