
# C99: Trigonometric
"""
    cr_acos(x)

Compute arc cosine of `x`.
"""
cr_acos(x::Float32) = cr_acosf(x)

"""
    cr_asin(x)

Compute arc-sine of `x`.
"""
cr_asin(x::Float32) = cr_asinf(x)

"""
    cr_atan(x)

Compute arc-tangent of `x`.
"""
cr_atan(x::Float32) = cr_atanf(x)

"""
    cr_atan2(y, x)

Compute arc-tangent of `y / x`.
"""
cr_atan2(y::Float32, x::Float32) = cr_atan2f(y, x)

# cos
# sin
# tan

# C99: Hyperbolic
# acosh
# asinh
# atanh
# cosh
# sinh
"""
    cr_tanh(x)

Compute hyperbolic tangent of `x`.
"""
cr_tanh(x::Float32) = cr_tanhf(x)

# C99: Exponential and logarithmic
# exp
# exp2
# expm1 
# log10
# log1p
# log2
# log

# C99: Power and Absolute-value
# pow
# sqrt

"""
    cr_rsqrt(x)

Computes the reciprocal square root of `x`.
"""
cr_rsqrt(x::Float32) = cr_rsqrtf(x)

# cbrt
# hypot

# C99: Error and gamma
# erf
# erfc
# lgamma
"""
    cr_tgamma(x)

Computes the true gamma function of `x`.
"""
cr_tgamma(x::Float32) = cr_tgammaf(x)
