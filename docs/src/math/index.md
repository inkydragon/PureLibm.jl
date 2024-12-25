# Implementation Status

> - [`func`](#): impl for both `Float32,Float64`
> - [`func(::Float32)`](#): impl only for `Float32`
> - `func`: Not-impl C99 Math Functions
> - func: Not-impl C23 Math Functions

## Trigonometric

- [`cr_acos(::Float32)`](@ref PureLibm.cr_acos)
- [`cr_asin(::Float32)`](@ref PureLibm.cr_asin)
- [`cr_atan(::Float32)`](@ref PureLibm.cr_atan)
- [`cr_atan2(::Float32)`](@ref PureLibm.cr_atan2)
- `cos`
- `sin`
- `tan`
- acospi
- asinpi
- atanpi
- atan2pi
- cospi
- sinpi
- tanpi


## Hyperbolic

- `acosh`
- `asinh`
- `atanh`
- `cosh`
- `sinh`
- [`cr_tanh`](@ref PureLibm.cr_tanh)

## Exponential and logarithmic

- `exp`
- `expm1`
- exp10
- exp10m1
- `exp2`
- exp2m1
- `log`
- `log1p`
- logp1
- `log10`
- log10p1
- `log2`
- log2p1

## Power

- `pow`
- pown
- powr
- rootn
- `sqrt`
- [`cr_rsqrt`](@ref PureLibm.cr_rsqrt)
- `cbrt`
- compoundn
- `hypot`

## Error and gamma

- `erf`
- `erfc`
- `lgamma`
- [`cr_tgamma(::Float32)`](@ref PureLibm.cr_tgamma)
