# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/acospi/acospif.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
    cr_acospi(x::Float32)

Correctly-rounded half-revolution arc-cosine function for `Float32` value.
This function computes `acos(x)/π`
"""
cr_acospi(x::Float32) = cr_acospif(x)

function cr_acospif(x::Float32)
    Float32(acos(x) / pi)
end
