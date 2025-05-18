# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log/logf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

"""
    cr_log2(x::Float32)

Correctly-rounded binary logarithm function for `Float32` value.

# Reference
- [src/binary32/log2/log2f.c](https://gitlab.inria.fr/core-math/core-math/-/blob/8656d7ca89538192366b4c14da5d034c87ac7d43/src/binary32/log2/log2f.c)
"""
cr_log2(x::Float32) = cr_log2f(x)

function cr_log2f(x::Float32)
    log2(x)
end
