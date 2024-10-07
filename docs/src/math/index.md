# Implementation Status

> - [`func`](#): impl for both `Float32,Float64`
> - [`func(::Float32)`](#): impl only for `Float32`
> - `func`: Not-impl C99 Math Functions
> - func: Not-impl C23 Math Functions

## Trigonometric

- [`acos(::Float32)`](@ref PureLibm.acos)
- [`asin(::Float32)`](@ref PureLibm.asin)
- [`atan(::Float32)`](@ref PureLibm.atan)
- [`atan2(::Float32)`](@ref PureLibm.atan2)
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
- `tanh`

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
- [`sqrt`](@ref PureLibm.sqrt)
- rsqrt
- [`cbrt`](@ref PureLibm.cbrt)
- compoundn
- `hypot`

## Error and gamma

- `erf`
- `erfc`
- `lgamma`
- `tgamma`
