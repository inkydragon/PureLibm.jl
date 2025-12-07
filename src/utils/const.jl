# SPDX-License-Identifier: MIT OR Apache-2.0
"""
# Reference

- IEEE 754
- [IEEE Support Functions - Oracle® Developer Studio 12.5: Numerical Computation Guide](https://docs.oracle.com/cd/E60778_01/html/E60763/z4000ac120180.html#OSSNCz4000ac119391)
- [Half-precision floating-point format - Wikipedia](https://en.wikipedia.org/wiki/Half-precision_floating-point_format#Half_precision_examples)
- [Single-precision floating-point format - Wikipedia](https://en.wikipedia.org/wiki/Single-precision_floating-point_format#Notable_single-precision_cases)
- [Double-precision floating-point format - Wikipedia](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
"""

"""Quiet NaN16"""
const QNaN16 = reinterpret(Float16, 0x7fff)
"""Signaling NaN16"""
const SNaN16 = reinterpret(Float16, 0x7f81)
"""Quiet NaN32"""
const QNaN32 = reinterpret(Float32, 0x7fffffff)
"""Signaling NaN32"""
const SNaN32 = reinterpret(Float32, 0x7f800001)
"""Quiet NaN64"""
const QNaN64 = reinterpret(Float64, 0x7fffffff_ffffffff)
"""Signaling NaN64"""
const SNaN64 = reinterpret(Float64, 0x7ff00000_00000001)


"""Quiet NaN"""
quiet_nan
quiet_nan(::Type{Float16}) = QNaN16
quiet_nan(::Type{Float32}) = QNaN32
quiet_nan(::Type{Float64}) = QNaN64

"""Signaling NaN"""
signaling_nan
signaling_nan(::Type{Float16}) = SNaN16
signaling_nan(::Type{Float32}) = SNaN32
signaling_nan(::Type{Float64}) = SNaN64

"""
Max Normal Float
"""
normal_max
normal_max(::Type{T}) where {T<:AbstractFloat} = floatmax(T)

"""
Min Normal Float
"""
normal_min
normal_min(::Type{T}) where {T<:AbstractFloat} = floatmin(T)

"""
Max Subnormal Float
"""
subnormal_max
subnormal_max(::Type{Float16}) = reinterpret(Float16, 0x03ff)
subnormal_max(::Type{Float32}) = reinterpret(Float32, 0x007fffff)
subnormal_max(::Type{Float64}) = reinterpret(Float64, 0x000fffff_ffffffff)

"""
Min Subnormal Float
"""
subnormal_min
subnormal_min(::Type{Float16}) = reinterpret(Float16, 0x0001)
subnormal_min(::Type{Float32}) = reinterpret(Float32, 0x00000001)
subnormal_min(::Type{Float64}) = reinterpret(Float64, 0x00000000_00000001)
