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

# --- fast mode: compare with system libm (takes serval seconds/minutes)
# Set ENV and run
export PURELIBM_CHECK_EXHAUSTIVE="cr_acos.fast"
julia --project=test -e "using Pkg; Pkg.test(\"PureLibm\");"

# --- slow mode: compare with MPFR (takes hours)
export PURELIBM_CHECK_EXHAUSTIVE="cr_acos"
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
