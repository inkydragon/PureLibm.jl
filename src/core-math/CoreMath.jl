# SPDX-License-Identifier: MIT OR Apache-2.0

export cr_acos


include("helper.jl")

# Trigonometric
include("binary32/acosf.jl")
include("binary32/asinf.jl")
include("binary32/atanf.jl")
# atan2f
include("binary32/cosf.jl")
include("binary32/cospif.jl")
include("binary32/sinf.jl")
include("binary32/sinpif.jl")
include("binary32/sincosf.jl")
include("binary32/tanf.jl")
include("binary32/tanpif.jl")

# Hyperbolic
include("binary32/acoshf.jl")
include("binary32/asinhf.jl")
include("binary32/atanhf.jl")
include("binary32/coshf.jl")
include("binary32/sinhf.jl")
include("binary32/tanhf.jl")

# Exponential and logarithmic
include("binary32/expf.jl")
include("binary32/exp10f.jl")
include("binary32/exp2f.jl")
include("binary32/expm1f.jl")
include("binary32/log1pf.jl")
include("binary32/logf.jl")

# Power
include("binary64/rsqrt.jl")
include("binary32/rsqrtf.jl")

# Error and gamma
include("binary32/tgammaf.jl")
