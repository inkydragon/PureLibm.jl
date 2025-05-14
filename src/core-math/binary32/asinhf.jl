# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/asinh/asinhf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

"""
Correctly-rounded inverse hyperbolic sine function for `Float32`.
"""
function cr_asinhf(x::Float32)
    asinh(x)
end
