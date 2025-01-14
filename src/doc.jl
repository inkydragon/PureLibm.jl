
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
# cr_atan2

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
"""
    cr_exp(x)

Compute natural exponential of `x`.
"""
cr_exp(x::Float32) = cr_expf(x)

"""
    cr_exp10(x)

Compute `10^x` of `x`.
"""
cr_exp10(x::Float32) = cr_exp10f(x)

"""
    cr_exp2(x)

Compute `2^x` of `x`.
"""
cr_exp2(x::Float32) = cr_exp2f(x)
# expm1 
# log10
"""
    cr_log1p(x)

Compute biased argument natural logarithm `log(1+x)` of `x`.
"""
cr_log1p(x::Float32) = cr_log1pf(x)
# log2
"""
    cr_log(x)

Compute natural logarithm of `x`.
"""
cr_log(x::Float32) = cr_logf(x)

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
