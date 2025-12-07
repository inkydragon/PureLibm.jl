# SPDX-License-Identifier: MIT OR Apache-2.0
"""
# Reference

- IEEE 754
- [IEEE Support Functions - Oracle® Developer Studio 12.5: Numerical Computation Guide](https://docs.oracle.com/cd/E60778_01/html/E60763/z4000ac120180.html#OSSNCz4000ac119391)
- [Single-precision floating-point format - Wikipedia](https://en.wikipedia.org/wiki/Single-precision_floating-point_format#Notable_single-precision_cases)
"""

"""Quiet NaN32"""
const QNaN32 = reinterpret(Float32, 0x7fffffff)
"""Signaling NaN32"""
const SNaN32 = reinterpret(Float32, 0x7f800001)


"""Quiet NaN"""
quiet_nan(::Type{Float32}) = QNaN32
"""Signaling NaN"""
signaling_nan(::Type{Float32}) = SNaN32

"""
Max Normal Float
"""
normal_max(::Type{T}) where {T<:AbstractFloat} = floatmax(T)

"""
Min Normal Float
"""
normal_min(::Type{T}) where {T<:AbstractFloat} = floatmin(T)

"""
Max Subnormal Float
"""
subnormal_max(::Type{Float32}) = reinterpret(Float32, 0x007fffff)

"""
Min Subnormal Float
"""
subnormal_min(::Type{Float32}) = reinterpret(Float32, 0x00000001)
