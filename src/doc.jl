
#= Trigonometric =#
"""
    cr_acos(x)

Compute the principal value of the arc cosine of `x`,
`acos` is the inverse function of `cos`,
`x = cos(acos(x))`.

Returns `arccos(x)` in interval `[0, π]` radians.
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

Compute the principal value of the arc sine of `x`,
`asin` is the inverse function of `sin`,
`x = sin(asin(x))`.

Returns `arcsin(x)` in interval `[-π/2, π/2]` radians.
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

Compute the principal value of the arc tangent of `x`,
`atan` is the inverse function of `tan`,
`x = tan(atan(x))`.

Returns `arctan(x)` in interval `[-π/2, π/2]` radians.
- Returns `±0` if `x` is `±0`
- Returns `±π/2` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [DLMF: §4.23.3](https://dlmf.nist.gov/4.23#E3)
- C23 F.10.1.3
"""
cr_atan

"""
    cr_atan2(y, x)

Compute the arc tangent of `y/x`.

Returns `arctan(y/x)` in interval `[-π, π]` radians.

- Returns `±π` if `(y = ±0, x = -0)`
- Returns `±0` if `(y = ±0, x = +0)`
- Returns `±π` if `(y = ±0, x < 0)`
- Returns `±0` if `(y = ±0, x > 0)`
- Returns `-π/2` if `(y < 0, x = ±0)`
- Returns `+π/2` if `(y > 0, x = ±0)`
- Returns `+π` if `(y > 0, x = -∞)` and `y` is finite
- Returns `-π` if `(y < 0, x = -∞)` and `y` is finite
- Returns `+0` if `(y > 0, x = +∞)` and `y` is finite
- Returns `-0` if `(y < 0, x = +∞)` and `y` is finite
- Returns `± π/2` if `(y = ±∞, x)` and `x` is finite
- Returns `±3π/4` if `(y = ±∞, x = -∞)`
- Returns `± π/4` if `(y = ±∞, x = +∞)`
- Returns `NaN` if `x` is `NaN` or `y` is `NaN`

# Reference
- [atan2 - Wikipedia](https://en.wikipedia.org/wiki/Atan2)
- C23 F.10.1.4
"""
cr_atan2

"""
    cr_cos(x)

Compute the cosine of `x` expressed in radians.

Returns `cos(x)` in interval `[-1, 1]`.
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

Compute the sine of `x` expressed in radians.

Returns `sin(x)` in interval `[-1, 1]`.
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

Compute the sine and cosine of `x` expressed in radians.

Returns `(sin(x), cos(x))` in interval `[-1, 1]`.
- Returns `(±0, 1)` if `x` is `±0`
- Returns `(NaN, NaN)` if `x` is `±∞`
- Returns `(NaN, NaN)` if `x` is `NaN`

# Reference
- sin: C23 F.10.1.6
- cos: C23 F.10.1.5
"""
cr_sincos

"""
    cr_tan(x)

Compute the tangent of `x` expressed in radians.

Returns `tan(x)` in interval `[-∞, ∞]`.
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

Compute the principal value of the arc cosine of `x`, divided by `π`,
thus measuring the angle in half-revolutions.

Returns `arccos(x)/π` in interval `[0, 1]`.
- Returns `+0` if `x` is `1`
- Returns `NaN` if `x` is `|x| > 1`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.8
"""
cr_acospi

"""
    cr_asinpi(x)

Compute the principal value of the arc sine of `x`, divided by `π`,
thus measuring the angle in half-revolutions.

Returns `arcsin(x)/π` in interval `[-1/2, 1/2]`.
- Returns `±0` if `x` is `±0`
- Returns `NaN` if `x` is `|x| > 1`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.9
"""
cr_asinpi

"""
    cr_atanpi(x)

Compute the principal value of the arc tangent of `x`, divided by `π`,
thus measuring the angle in half-revolutions.

Returns `arctan(x)/π` in interval `[-1/2, 1/2]`.
- Returns `±0` if `x` is `±0`
- Returns `±1/2` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- C23 F.10.1.10
"""
cr_atanpi

"""
    cr_atan2pi(y, x)

Compute the principal value of the arc tangent of `y/x`, divided by `π`,
thus measuring the angle in half-revolutions.

Returns `arctan(y, x)/π` in interval `[-1, 1]`.

# Reference
- C23 F.10.1.11
"""
cr_atan2pi

"""
    cr_cospi(x)

Compute the cosine of `π*x` expressed in half-revolutions.

Returns `cos(π*x)` in interval `[-1, 1]`.
- Returns `1` if `x` is `±0`
- Returns `+0` if `x` is `n + 1/2`, for integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [cospi - cppreference](https://en.cppreference.com/w/c/numeric/math/cospi)
- C23 F.10.1.12
"""
cr_cospi

"""
    cr_sinpi(x)

Compute the sine of `π*x` expressed in half-revolutions.

Returns `sin(π*x)` in interval `[-1, 1]`.
- Returns `±0` if `x` is `±0`
- Returns `±0` if `x` is `±n`, for positive integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [sinpi - cppreference](https://en.cppreference.com/w/c/numeric/math/sinpi)
- C23 F.10.1.13
"""
cr_sinpi

"""
    cr_tanpi(x)

Compute the tangent of `π*x` expressed in half-revolutions.

Returns `tan(π*x)` in interval `[-∞, ∞]`.
- Returns `±0` if `x` is `±0`
- Returns `+0` if `x` is `n`, for positive even and negative odd integers `n`
- Returns `-0` if `x` is `n`, for positive odd and negative even integers `n`
- Returns `+∞` if `x` is `n + 1/2`, for even integers `n`
- Returns `-∞` if `x` is `n + 1/2`, for odd integers `n`
- Returns `NaN` if `x` is `±∞`
- Returns `NaN` if `x` is `NaN`

# Reference
- [tanpi - cppreference](https://en.cppreference.com/w/c/numeric/math/tanpi)
- C23 F.10.1.14
"""
cr_tanpi


#= Hyperbolic =#
"""
    cr_acosh(x)

Compute the (nonnegative) arc hyperbolic cosine of `x`,
`acosh` is the inverse function of `cosh`,
`x = cosh(acosh(x))`.

Returns `arccosh(x)` in interval `[0, ∞]`.
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

Compute the arc hyperbolic sine of `x`,
`asinh` is the inverse function of `sinh`,
`x = sinh(asinh(x))`.

Returns `arcsinh(x)` in interval `[-∞, ∞]`.
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

Compute the arc hyperbolic tangent of `x`,
`atanh` is the inverse function of `tanh`,
`x = tanh(atanh(x))`.

Returns `arctanh(x)` in interval `[-∞, ∞]`.
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

Compute the hyperbolic cosine of `x`.

Returns `cosh(x)` in interval `[1, ∞]`.
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

Compute the hyperbolic sine of `x`.

Returns `sinh(x)` in interval `[-∞, ∞]`.
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

Compute the hyperbolic tangent of `x`.

Returns `tanh(x)` in interval `[-1, 1]`.
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

Compute the base-`e` exponential of `x`,
a.k.a. natural exponential.

Returns ``e^x``

# Reference
- [DLMF: §4.2.19](https://dlmf.nist.gov/4.2#E19)
- C23 F.10.3.1
"""
cr_exp

"""
    cr_exp10(x)

Compute the base-`10` exponential of `x`.

Returns ``10^x``

# Reference
- C23 F.10.3.2
"""
cr_exp10

"""
    cr_exp10m1(x)

Compute the base-`10` exponential of `x`, minus 1.

Returns ``10^x - 1``

# Reference
- C23 F.10.3.3
"""
cr_exp10m1

"""
    cr_exp2(x)

Compute the base-`2` exponential of `x`.

Returns ``2^x``

# Reference
- [exp2 - cppreference](https://en.cppreference.com/w/c/numeric/math/exp2)
- C23 F.10.3.4
"""
cr_exp2

"""
    cr_exp2m1(x)

Compute the base-`2` exponential of `x`, minus 1.

Returns ``2^x - 1``

# Reference
- C23 F.10.3.5
"""
cr_exp2m1

"""
    cr_expm1(x)

Compute the base-`e` exponential of `x`, minus 1.

Returns ``e^x - 1``

# Reference
- [expm1 - cppreference](https://en.cppreference.com/w/c/numeric/math/expm1)
- C23 F.10.3.6
"""
cr_expm1

"""
    cr_log(x)

Compute the base-`e` logarithm of `x`,
a.k.a. natural logarithm.

Returns ``\\log_e x``

# Reference
- [DLMF: §4.2.2](https://dlmf.nist.gov/4.2#E2)
- C23 F.10.3.11
"""
cr_log

"""
    cr_log10(x)

Compute the base-`10` logarithm of `x`,
a.k.a. common logarithm.

Returns ``\\log_{10} x``

# Reference
- [log10 - cppreference](https://en.cppreference.com/w/c/numeric/math/log10)
- C23 F.10.3.12
"""
cr_log10

"""
    cr_log10p1(x)

Compute the base-`10` logarithm of `1 + x`.

Returns ``\\log_{10} (1+x)``

# Reference
- C23 F.10.3.13
"""
cr_log10p1

"""
    cr_log1p(x)

Compute the base-`e` logarithm of `1 + x`.

Returns ``\\log_e (1+x)``

# Reference
- [log1p - cppreference](https://en.cppreference.com/w/c/numeric/math/log1p)
- C23 F.10.3.14
"""
cr_log1p
const cr_logp1 = cr_log1p

"""
    cr_log2(x)

Compute the base-`2` logarithm of `x`.

Returns ``\\log_2 x``

# Reference
- [log2 - cppreference](https://en.cppreference.com/w/c/numeric/math/log2)
- C23 F.10.3.15
"""
cr_log2

"""
    cr_log2p1(x)

Compute the base-`2` logarithm of `1 + x`.

Returns ``\\log_2 (1+x)``

# Reference
- C23 F.10.3.16
"""
cr_log2p1


#= Power and Absolute-value =#
"""
    cr_cbrt(x)

Compute the real cube root of `x`.

Returns ``x^\\frac{1}{3}``

# Reference
- [cbrt - cppreference](https://en.cppreference.com/w/c/numeric/math/cbrt)
- C23 F.10.4.1
"""
cr_cbrt

"""
    cr_compoundn(x, n)

Compute `1 + x` raised to the power `n`.

Returns ``(1+x)^n``

# Reference
- C23 7.12.7.2, F.10.4.2
"""
cr_compoundn

"""
    cr_hypot(x, y)

Compute the square root of the sum of the squares of `x` and `y`,
without undue overflow or underflow.

Returns ``\\sqrt{x^2+y^2}``

# Reference
- [hypot - cppreference](https://en.cppreference.com/w/c/numeric/math/hypot)
- C23 F.10.4.4
"""
cr_hypot

"""
    cr_pow(x, y)

Compute `x` raised to the power `y`.

Returns ``\\x^y``

# Reference
- [DLMF: §4.2.28](https://dlmf.nist.gov/4.2#E28)
- C23 F.10.4.5
"""
cr_pow
# pown
# powr
# rootn

"""
    cr_rsqrt(x)

Computes the reciprocal of the nonnegative square root of `x`.

Returns ``\\frac{1}{\\sqrt{x}}``

# Reference
- C23 F.10.4.9
"""
cr_rsqrt

"""
    cr_sqrt(x)

Computes the nonnegative square root of `x`.

Returns ``\\sqrt{x}``

# Reference
- [sqrt - cppreference](https://en.cppreference.com/w/c/numeric/math/sqrt)
- C23 F.10.4.10
"""
cr_sqrt


#= Error and gamma =#
"""
    cr_erf(x)

Computes the error function of `x`.

Returns
```math
\\tt{erf}(x) = \\frac{2}{\\sqrt{\\pi}} \\int_{0}^{x} e^{-t^2} dt
```

# Reference
- [DLMF: §7.2.1](https://dlmf.nist.gov/7.2#E1)
- C23 F.10.5.1
"""
cr_erf

"""
    cr_erfc(x)

Computes the complementary error function of `x`.

Returns
```math
\\tt{erfc}(x)
= 1 - \\tt{erf}(x)
= \\frac{2}{\\sqrt{\\pi}} \\int_{x}^{\\infty} e^{-t^2} dt
```

# Reference
- [DLMF: §7.2.2](https://dlmf.nist.gov/7.2#E2)
- C23 F.10.5.2
"""
cr_erfc

"""
    cr_lgamma(x)

Computes the natural logarithm of the absolute value of gamma of `x`.

Returns ``\\log_e |\\Gamma(x)|``

# Reference
- [lgamma - cppreference](https://en.cppreference.com/w/c/numeric/math/lgamma)
- C23 F.10.5.3
"""
cr_lgamma

"""
    cr_tgamma(x)

Computes the true gamma function of `x`.

Returns ``\\Gamma(x)``

# Reference
- [DLMF: §5.2.1](https://dlmf.nist.gov/5.2#E1)
- C23 F.10.5.4
"""
cr_tgamma
