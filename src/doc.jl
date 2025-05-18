
#= Trigonometric =#
"""
    cr_acos(x)

Compute the inverse cosine of `x` in radians.

Returns the arc-cosine of `x` in ranges `[0, pi]`.
- Returns `+0` if `x` is `1`
- Returns `NaN` if `x` is `|x| > 1`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.23.2](https://dlmf.nist.gov/4.23#E2)
- C23 F.10.1.1
"""
cr_acos

"""
    cr_asin(x)

Compute the inverse sine of `x` in radians.

Returns the arc-sine of `x` in ranges `[-pi/2, pi/2]`.
- Returns `±0` if `x` is `±0`
- Returns `NaN` if `x` is `|x| > 1`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.23.1](https://dlmf.nist.gov/4.23#E1)
- C23 F.10.1.2
"""
cr_asin

"""
    cr_atan(x)

Compute the inverse tangent of `x` in radians.

Returns the arc-tangent of `x` in ranges `[-pi/2, pi/2]`.
- Returns `±0` if `x` is `±0`
- Returns `±π/2` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.23.3](https://dlmf.nist.gov/4.23#E3)
- C23 F.10.1.3
"""
cr_atan

"""
    cr_atan2(x, y)

# Reference
- C23 F.10.1.4
"""
cr_atan2

"""
    cr_cos(x)

Compute the cosine of `x` in radians.

Returns the cosine of `x` in ranges `[-1, 1]`.
- Returns `1` if `x` is `±0`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.14.2](https://dlmf.nist.gov/4.14#E2)
- C23 F.10.1.5
"""
cr_cos

"""
    cr_sin(x)

Compute the sine of `x` in radians.

Returns the sine of `x` in ranges `[-1, 1]`.
- Returns `±0` if `x` is `±0`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.14.1](https://dlmf.nist.gov/4.14#E1)
- C23 F.10.1.6
"""
cr_sin

"""
    cr_sincos(x)

Compute the sine and cosine of `x` in radians.
"""
cr_sincos

"""
    cr_tan(x)

Compute the tangent of `x` in radians.

Returns the tangent of `x` in ranges `[-∞, ∞]`.
- Returns `±0` if `x` is `±0`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.14.4](https://dlmf.nist.gov/4.14#E4)
- C23 F.10.1.7
"""
cr_tan

"""
    cr_acospi(x)

Compute the inverse cosine of `x` divided by `π`.

# Reference
- C23 F.10.1.8
"""
cr_acospi

"""
    cr_asinpi(x)

Compute the inverse sine of `x` divided by `π`.

# Reference
- C23 F.10.1.9
"""
cr_asinpi

"""
    cr_atanpi(x)

Compute the inverse tangent of `x` divided by `π`.

# Reference
- C23 F.10.1.10
"""
cr_atanpi

"""
    cr_atan2pi(x)

# Reference
- C23 F.10.1.11
"""
cr_atan2pi

"""
    cr_cospi(x)

Compute the cosine of `x*pi` in radians.

Returns the cosine of `x` in ranges `[-1, 1]`.
- Returns `1` if `x` is `±0`
- Returns `+0` if `x` is `n + 1/2`, for integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.12
"""
cr_cospi

"""
    cr_sinpi(x)

Compute the sine of `x*pi` in radians.

Returns the sine of `x` in ranges `[-1, 1]`.
- Returns `±0` if `x` is `±0`
- Returns `±0` if `x` is `±n`, for positive integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.13
"""
cr_sinpi

"""
    cr_tanpi(x)

Compute the tangent of `x*pi` in radians.

Returns the tangent of `x` in ranges `[-∞, ∞]`.
- Returns `±0` if `x` is `±0`
- Returns `+0` if `x` is `n`, for positive even and negative odd integers `n`
- Returns `-0` if `x` is `n`, for positive odd and negative even integers `n`
- Returns `+∞` if `x` is `n + 1/2`, for even integers `n`
- Returns `-∞` if `x` is `n + 1/2`, for odd integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.14
"""
cr_tanpi


#= Hyperbolic =#
"""
    cr_acosh(x)

Compute the inverse hyperbolic cosine of `x` in radians.

Returns the inverse hyperbolic cosine of `x`.
- Returns `+0` if `x` is `1`
- Returns `NaN` if `x` is `x < 1`
- Returns `+∞` if `x` is `+∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.37.2](https://dlmf.nist.gov/4.37#E2)
- C23 F.10.2.1
"""
cr_acosh

"""
    cr_asinh(x)

Compute the inverse hyperbolic sine of `x` in radians.

Returns the inverse hyperbolic sine of `x`.
- Returns `±0` if `x` is `±0`
- Returns `±∞` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.37.1](https://dlmf.nist.gov/4.37#E1)
- C23 F.10.2.2
"""
cr_asinh

"""
    cr_atanh(x)

Compute the inverse hyperbolic tangent of `x` in radians.

Returns the inverse hyperbolic tangent of `x`.
- Returns `±0` if `x` is `±0`
- Returns `±∞` if `x` is `±1`
- Returns `NaN` if `x` is `|x| > 1`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.37.3](https://dlmf.nist.gov/4.37#E3)
- C23 F.10.2.3
"""
cr_atanh

"""
    cr_cosh(x)

Compute the hyperbolic cosine of `x` in radians.

Returns the hyperbolic cosine of `x`.
- Returns `1` if `x` is `±0`
- Returns `+∞` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.28.2](https://dlmf.nist.gov/4.28#E2)
- C23 F.10.2.4
"""
cr_cosh

"""
    cr_sinh(x)

Compute the hyperbolic sine of `x` in radians.

Returns the hyperbolic sine of `x`.
- Returns `±0` if `x` is `±0`
- Returns `±∞` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.28.1](https://dlmf.nist.gov/4.28#E1)
- C23 F.10.2.5
"""
cr_sinh

"""
    cr_tanh(x)

Compute the hyperbolic tangent of `x` in radians.

Returns the hyperbolic tangent of `x`.
- Returns `±0` if `x` is `±0`
- Returns `±1` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.28.4](https://dlmf.nist.gov/4.28#E4)
- C23 F.10.2.6
"""
cr_tanh


#= Exponential and logarithmic =#
"""
    cr_exp(x)

Compute natural exponential of `x`.

# Reference
- C23 F.10.3.1
"""
cr_exp(x::Float32) = cr_expf(x)

"""
    cr_exp10(x)

Compute `10^x` of `x`.

# Reference
- C23 F.10.3.2
"""
cr_exp10(x::Float32) = cr_exp10f(x)

"""
    cr_exp10m1(x)

# Reference
- C23 F.10.3.3
"""
# cr_exp10m1

"""
    cr_exp2(x)

Compute `2^x` of `x`.

# Reference
- C23 F.10.3.4
"""
cr_exp2(x::Float32) = cr_exp2f(x)

"""
    cr_exp2m1(x)

# Reference
- C23 F.10.3.5
"""
# cr_exp2m1

"""
    cr_expm1(x)

Compute `exp(x) - 1` of `x`.

# Reference
- C23 F.10.3.6
"""
cr_expm1(x::Float32) = cr_expm1f(x)

"""
    cr_log(x)

Compute natural logarithm of `x`.

# Reference
- C23 F.10.3.11
"""
cr_log(x::Float32) = cr_logf(x)

"""
    cr_log10(x)

Compute base 10 logarithm of `x`.

# Reference
- C23 F.10.3.12
"""
cr_log10

"""
    cr_log10p1(x)

# Reference
- C23 F.10.3.13
"""
# cr_log10p1

"""
    cr_log1p(x)

Compute biased argument natural logarithm `log(1+x)` of `x`.

# Reference
- C23 F.10.3.14
"""
cr_log1p(x::Float32) = cr_log1pf(x)
const cr_logp1 = cr_log1p

"""
    cr_log2(x)

Compute natural logarithm of `x`.

# Reference
- C23 F.10.3.15
"""
cr_log2

"""
    cr_log2p1(x)

# Reference
- C23 F.10.3.16
"""
# cr_log2p1


#= Power and Absolute-value =#
"""
    cr_cbrt(x)

Compute cubic root of `x`.

# Reference
- C23 F.10.4.1
"""
cr_cbrt
# compoundn

"""
    cr_hypot(x)

# Reference
- C23 F.10.4.4
"""
# cr_hypot

"""
    cr_pow(x)

# Reference
- C23 F.10.4.5
"""
# cr_pow
# pown
# powr
# rootn

"""
    cr_rsqrt(x)

Computes the reciprocal square root of `x`.

# Reference
- C23 F.10.4.9
"""
cr_rsqrt(x::Float32) = cr_rsqrtf(x)

"""
    cr_sqrt(x)

# Reference
- C23 F.10.4.10
"""
# cr_sqrt


#= Error and gamma =#
"""
    cr_erf(x)

# Reference
- C23 F.10.5.1
"""
# cr_erf

"""
    cr_erfc(x)

# Reference
- C23 F.10.5.2
"""
# cr_erfc

"""
    cr_lgamma(x)

# Reference
- C23 F.10.5.3
"""
# cr_lgamma

"""
    cr_tgamma(x)

Computes the true gamma function of `x`.
    
# Reference
- C23 F.10.5.4
"""
cr_tgamma(x::Float32) = cr_tgammaf(x)
