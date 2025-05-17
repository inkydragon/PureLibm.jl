# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atanpi/atanpif.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
    cr_atanpi(x::Float32)

Correctly-rounded half-revolution arc-tangent of `Float32` value
"""
cr_atanpi(x::Float32) = cr_atanpif(x)

function cr_atanpif(x::Float32)
    Float32(atan(x) / pi)
end
