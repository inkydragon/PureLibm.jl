# Implementation Status

> - [`func`](#): impl for both `Float32,Float64`
> - [`func(Float32)`](#): impl only for `Float32`
> - `func`: Not-impl C99 Math Functions
> - func: Not-impl C23 Math Functions

## Trigonometric

- [`cr_acos(Float32)`](@ref PureLibm.cr_acos)
- [`cr_asin(Float32)`](@ref PureLibm.cr_asin)
- [`cr_atan(Float32)`](@ref PureLibm.cr_atan)
- `atan2`
- [`cr_cos(Float32)`](@ref PureLibm.cr_cos)
- [`cr_sin(Float32)`](@ref PureLibm.cr_sin)
- [`cr_tan(Float32)`](@ref PureLibm.cr_tan)
- acospi
- asinpi
- atanpi
- atan2pi
- cospi
- [`cr_sinpi(Float32)`](@ref PureLibm.cr_sinpi)
- tanpi

## Hyperbolic

- `acosh`
- `asinh`
- `atanh`
- [`cr_cosh(Float32)`](@ref PureLibm.cr_cosh)
- `sinh`
- [`cr_tanh(Float32)`](@ref PureLibm.cr_tanh)

## Exponential and logarithmic

- [`cr_exp(Float32)`](@ref PureLibm.cr_exp)
- [`cr_exp10(Float32)`](@ref PureLibm.cr_exp10)
- exp10m1
- [`cr_exp2(Float32)`](@ref PureLibm.cr_exp2)
- exp2m1
- [`cr_expm1(Float32)`](@ref PureLibm.cr_expm1)
- [`cr_log(Float32)`](@ref PureLibm.cr_log)
- `log10`
- log10p1
- [`cr_log1p(Float32)`](@ref PureLibm.cr_log1p)
- logp1
- `log2`
- log2p1

## Power

- `cbrt`
- compoundn
- `hypot`
- `pow`
- pown
- powr
- rootn
- [`cr_rsqrt(Float32)`](@ref PureLibm.cr_rsqrt)
- `sqrt`

## Error and gamma

- `erf`
- `erfc`
- `lgamma`
- [`cr_tgamma(Float32)`](@ref PureLibm.cr_tgamma)
