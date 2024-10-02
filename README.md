# PureLibm

> A pure Julia math library

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://inkydragon.github.io/PureLibm.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://inkydragon.github.io/PureLibm.jl/dev/)
[![Build Status](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/inkydragon/PureLibm.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/inkydragon/PureLibm.jl)


## Implementation Goals
1. As accurate as possible.
    - The input of `Float32` should pass the exhaustive checking
    - The result of `Float64` should match the output of CORE-MATH.
    - Rounding mode: Only `FE_TONEAREST` for now.
    - Other rounding modes will be considered after the completion of `FE_TONEAREST`.
2. Code readability.
    - Magic numbers should not be used, use named constant.
    - If it is possible to use absolute values, do not use shifted values.
    - For algorithm implementations, the implementation logic in the references should be followed as much as possible, even if it has an impact on performance.
3. Performance should be considered after the implementation is complete, with a lower priority than correctness.
    - If refactoring the algorithm improves performance, implementations that match the original reference are retained as references for testing purposes.


## Dev Memo

### Build doc
```sh
julia --project=docs -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"
julia --project=docs docs/make.jl
```

```julia
using Pkg; using LocalCoverage; Pkg.add(url=".");  html_coverage(generate_coverage("PureLibm"; run_test=true); dir = "../cov")
```


## License
```
// SPDX-License-Identifier: MIT OR Apache-2.0
```

PureLibm.jl is licensed under either of

- MIT license ([LICENSE-MIT](LICENSE-MIT))
- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))

at your option.
