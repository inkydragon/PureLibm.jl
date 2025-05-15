# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan/atanf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.


"""
Correctly-rounded tangent of `Float32` for angles.
"""
function cr_tanpif(x::Float32)
    tanpi(x)
end
