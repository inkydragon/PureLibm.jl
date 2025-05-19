# SPDX-License-Identifier: MIT OR Apache-2.0

export cr_acos, cr_asin, cr_atan


include("helper.jl")

# Trigonometric
include("binary32/acosf.jl")
include("binary32/asinf.jl")
include("binary32/atanf.jl")
include("binary32/atan2f.jl")
include("binary32/cosf.jl")
include("binary32/sinf.jl")
include("binary32/sincosf.jl")
include("binary32/tanf.jl")
include("binary32/acospif.jl")
include("binary32/asinpif.jl")
include("binary32/atanpif.jl")
# atan2pi
include("binary32/cospif.jl")
include("binary32/sinpif.jl")
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
# exp10m1
include("binary32/exp2f.jl")
# exp2m1
include("binary32/expm1f.jl")
include("binary32/logf.jl")
include("binary32/log10f.jl")
# log10p1
include("binary32/log1pf.jl")
# logp1
include("binary32/log2f.jl")
# log2p1

# Power
include("binary32/cbrtf.jl")
# compoundn
# hypot
# pow
include("binary64/rsqrt.jl")
include("binary32/rsqrtf.jl")

# Error and gamma
include("binary32/tgammaf.jl")
