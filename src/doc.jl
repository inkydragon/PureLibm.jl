
#= Trigonometric =#
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

"""
    cr_cos(x)

Compute cosine of `x`.
"""
cr_cos(x::Float32) = cr_cosf(x)

"""
    cr_sin(x)

Compute sine of `x`.
"""
cr_sin(x::Float32) = cr_sinf(x)

"""
    cr_sincos(x)

Compute sine and cosine of `x`.
"""
cr_sincos(x::Float32) = cr_sincosf(x)

"""
    cr_tan(x)

Compute tangent of `x`.
"""
cr_tan(x::Float32) = cr_tanf(x)

# acospi
# asinpi
# atanpi
# atan2pi

# cospi
"""
    cr_sinpi(x)

Compute sine of `x*pi`.
"""
cr_sinpi(x::Float32) = cr_sinpif(x)
# tanpi


#= Hyperbolic =#
"""
    cr_acosh(x)

Compute inverse hyperbolic cosine of `x`.
"""
cr_acosh(x::Float32) = cr_acoshf(x)

"""
    cr_asinh(x)

Compute inverse hyperbolic sine of `x`.
"""
cr_asinh(x::Float32) = cr_asinhf(x)
# atanh

"""
    cr_cosh(x)

Compute hyperbolic cosine of `x`.
"""
cr_cosh(x::Float32) = cr_coshf(x)
# sinh

"""
    cr_tanh(x)

Compute hyperbolic tangent of `x`.
"""
cr_tanh(x::Float32) = cr_tanhf(x)


#= Exponential and logarithmic =#
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
# exp10m1

"""
    cr_exp2(x)

Compute `2^x` of `x`.
"""
cr_exp2(x::Float32) = cr_exp2f(x)
# exp2m1

"""
    cr_expm1(x)

Compute `exp(x) - 1` of `x`.
"""
cr_expm1(x::Float32) = cr_expm1f(x)

"""
    cr_log(x)

Compute natural logarithm of `x`.
"""
cr_log(x::Float32) = cr_logf(x)
# log10
# log10p1

"""
    cr_log1p(x)

Compute biased argument natural logarithm `log(1+x)` of `x`.
"""
cr_log1p(x::Float32) = cr_log1pf(x)
# logp1
# log2
# log2p1


#= Power and Absolute-value =#
# cbrt
# compoundn
# hypot

# pow
# pown
# powr
# rootn

"""
    cr_rsqrt(x)

Computes the reciprocal square root of `x`.
"""
cr_rsqrt(x::Float32) = cr_rsqrtf(x)
# sqrt


#= Error and gamma =#
# erf
# erfc

# lgamma
"""
    cr_tgamma(x)

Computes the true gamma function of `x`.
"""
cr_tgamma(x::Float32) = cr_tgammaf(x)
