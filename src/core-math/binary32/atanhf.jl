# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atanh/atanhf.c
# CORE-MATH project Copyright (c) 2023-2025 Alexei Sibidanov.

"""
Correctly-rounded inverse hyperbolic tangent of `Float32`.
"""
function cr_atanhf(x::Float32)
    atanh(x)
end
