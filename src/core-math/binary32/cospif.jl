# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/cospi/cospif.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
Correctly-rounded cosine of `Float32` for angles.
"""
function cr_cospif(x::Float32)
    cos(x * pi)
end
