# PureLibm

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://inkydragon.github.io/PureLibm.jl/dev/)
[![Build Status](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/inkydragon/PureLibm.jl/graph/badge.svg?token=bxtVgfRQ7R)](https://codecov.io/gh/inkydragon/PureLibm.jl)

> A correctly rounded maths library in pure Julia.

## Implementation Goals

1. As accurate as possible.
    - The input of `Float32` should pass the exhaustive checking
    - The result of `Float64` should match the output of CORE-MATH.
    - Rounding mode: Only `FE_TONEAREST` for now.
    - Other rounding modes will be considered after the `FE_TONEAREST` mode is implemented.
2. Code readability.
    - Magic numbers should not be used, use named constant.
    - Whenever possible, give the origin of the magic number, and the process of calculating it.
    - Avoid complex bit manipulations, and if possible use the corresponding functions instead of them.
        Or wrap the corresponding operations in a function.
3. Performance should be considered after the implementation is complete, with a lower priority than correctness.

## Implementation Status

Check the API docs:

- [Float32 API](https://inkydragon.github.io/PureLibm.jl/dev/reference/f32/)
- [Float64 API](https://inkydragon.github.io/PureLibm.jl/dev/reference/f64/)

## Dev Memo

### Run tests

```sh
# The following command will init test project in the `test/` directory.
#   You only need to run this line once.
julia --project=test -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"
julia --project=test -e "using Pkg; Pkg.test(\"PureLibm\");"
```

### Build docs

```sh
# The following command will init docs project in the `docs/` directory.
#   You only need to run this line once.
julia --project=docs -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"
julia --project=docs docs/make.jl
# html files located in `docs/build/`
```

### Gen Test Coverage

> - You need [`lcov`](https://github.com/linux-test-project/lcov)
>   in your `PATH` to gen test coverage report.
> - See also: [JuliaCI/LocalCoverage.jl](https://github.com/JuliaCI/LocalCoverage.jl)

```sh
julia --project=test -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"
# Open REPL in test/
julia --project=test
```

In Julia REPL:

```jl
# In Julia REPL
using Pkg; using LocalCoverage; Pkg.add(url=".");  html_coverage(generate_coverage("PureLibm"; run_test=true); dir = "../cov")
# in logs:  `Found common filename prefix "/home/cyhan/.julia/packages/PureLibm/bbJui"`
# so coverage html files located in  `~/.julia/packages/PureLibm/cov/`

# Test in another branch instead of `main` (default branch)
using Pkg; using LocalCoverage; Pkg.add(url=".", rev="dev");  html_coverage(generate_coverage("PureLibm"; run_test=true); dir = "../cov")
```

### Run exhaustive tests

```sh
julia --project=test -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"

# --- fast mode: compare with system libm (takes several seconds/minutes)
# Set ENV and run
export PURELIBM_CHECK_EXHAUSTIVE=""
# Trigonometric
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acos.fast,cr_asin.fast,cr_atan.fast,cr_atan2.fast,cr_cos.fast,cr_sin.fast,cr_tan.fast"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acospi.fast,cr_asinpi.fast,cr_atanpi.fast,cr_atan2pi.fast,cr_cospi.fast,cr_sinpi.fast,cr_tanpi.fast"
# Hyperbolic
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acosh.fast,cr_asinh.fast,cr_atanh.fast,cr_cosh.fast,cr_sinh.fast,cr_tanh.fast"
# Exponential and logarithmic
PURELIBM_CHECK_EXHAUSTIVE+=",cr_exp.fast,cr_exp10.fast,cr_exp10m1.fast,cr_exp2.fast,cr_exp2m1.fast,cr_expm1.fast"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_log.fast,cr_log10.fast,cr_log10p1.fast,cr_log1p.fast,cr_log2.fast,cr_log2p1.fast"
# Power and Absolute-value
# PURELIBM_CHECK_EXHAUSTIVE+=",cr_cbrt.fast,cr_compoundn.fast,cr_hypot.fast,cr_pow.fast,cr_rsqrt.fast,cr_sqrt.fast"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_cbrt.fast,cr_rsqrt.fast,cr_sqrt.fast"
# Error and gamma
PURELIBM_CHECK_EXHAUSTIVE+=",cr_erf.fast,cr_erfc.fast,cr_lgamma.fast,cr_tgamma.fast"
julia --project=test -e "using Pkg; Pkg.test(\"PureLibm\");"

# --- slow mode: compare with MPFR (takes hours)
export PURELIBM_CHECK_EXHAUSTIVE=""
# Trigonometric
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acos,cr_asin,cr_atan,cr_atan2,cr_cos,cr_sin,cr_tan"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acospi,cr_asinpi,cr_atanpi,cr_atan2pi,cr_cospi,cr_sinpi,cr_tanpi"
# Hyperbolic
PURELIBM_CHECK_EXHAUSTIVE+=",cr_acosh,cr_asinh,cr_atanh,cr_cosh,cr_sinh,cr_tanh"
# Exponential and logarithmic
PURELIBM_CHECK_EXHAUSTIVE+=",cr_exp,cr_exp10,cr_exp10m1,cr_exp2,cr_exp2m1,cr_expm1"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_log,cr_log10,cr_log10p1,cr_log1p,cr_log2,cr_log2p1"
# Power and Absolute-value
# PURELIBM_CHECK_EXHAUSTIVE+=",cr_cbrt,cr_compoundn,cr_hypot,cr_pow,cr_rsqrt,cr_sqrt"
PURELIBM_CHECK_EXHAUSTIVE+=",cr_cbrt,cr_rsqrt,cr_sqrt"
# Error and gamma
PURELIBM_CHECK_EXHAUSTIVE+=",cr_erf,cr_erfc,cr_lgamma,cr_tgamma"
julia --project=test -e "using Pkg; Pkg.test(\"PureLibm\");"
```

## License

```c
// SPDX-License-Identifier: MIT OR Apache-2.0
```

`PureLibm.jl` is licensed under either of

- MIT license ([LICENSE-MIT](LICENSE-MIT))
- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))

at your option.
