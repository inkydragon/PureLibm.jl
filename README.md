# PureLibm

> A pure Julia math library

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://inkydragon.github.io/PureLibm.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://inkydragon.github.io/PureLibm.jl/dev/)
[![Build Status](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/inkydragon/PureLibm.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/inkydragon/PureLibm.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/inkydragon/PureLibm.jl)


## Dev Memo

### Build doc
```sh
julia --project=docs -e "using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate();"
julia --project=docs docs/make.jl
```


## License
```
// SPDX-License-Identifier: MIT OR Apache-2.0
```

PureLibm.jl is licensed under either of

- MIT license ([LICENSE-MIT](LICENSE-MIT))
- Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE))

at your option.
