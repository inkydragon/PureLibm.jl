# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/sqrt/sqrtf.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

"""
    cr_sqrt(x::Float32)

Correctly-rounded reciprocal square root of binary32 value.

!!! warning
    This function is not implemented yet

# Examples
```jldoctest
julia> PureLibm.cr_sqrt.(Float32[0.0, 1e-4, 1e-10, 1e-30])
4-element Vector{Float32}:
 0.0
 0.01
 1.0f-5
 1.0f-15

julia> PureLibm.cr_cbrt(Inf32)
Inf32
```

See also: [`cr_rsqrt(::Float32)`](@ref)

# Reference

"""
cr_sqrt(x::Float32) = cr_sqrtf(x)

function cr_sqrtf(x::Float32)
    sqrt(x)
end
