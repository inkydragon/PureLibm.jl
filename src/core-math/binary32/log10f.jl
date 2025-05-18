# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log10/log10f.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

#! format: off
# Keep same format as in log10f.c
const CR_LOG10F_TR = Vector{Float64}([

])


const CR_LOG2F_C = NTuple{6, Float64}((

))
#! format: on

"""
    cr_log10(x::Float32)

Correctly-rounded radix-10 logarithm function for binary32 value.

# Reference
-
"""
cr_log10(x::Float32) = cr_log10f(x)

function cr_log10f(x::Float32)
    log10(x)
end
