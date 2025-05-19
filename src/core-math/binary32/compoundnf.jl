# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/compoundn/compoundnf.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov and Paul Zimmermann.

"""
    cr_compoundn(x::Float32, n::Float32)

Correctly-rounded compound function for binary32 values.

!!! warning
    This function is not implemented yet
"""
cr_compoundn(x::Float32, n::Float32) = cr_compoundnf(x, n)

function cr_compoundnf(x::Float32, n::Float32)
    (1.0f0 + x)^n
end
