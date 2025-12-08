# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atan2/atan2f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov and Paul Zimmermann.

"""
    cr_atan2(y::Float32, x::Float32)

Correctly-rounded arctangent function of two `Float32` values.

!!! warning
    This function is not implemented yet

# Examples
```jldoctest
julia> nothing

```

See also: [`cr_atan2pi(::Float32, ::Float32)`](@ref)

# Reference

"""
cr_atan2(y::Float32, x::Float32) = cr_atan2f(y, x)

function cr_atan2f(y::Float32, x::Float32)
    throw(ErrorException("Function Not Impl!"))
end
