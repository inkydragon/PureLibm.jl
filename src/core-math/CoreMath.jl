# SPDX-License-Identifier: MIT OR Apache-2.0

include("helper.jl")

# Trigonometric
include("binary32/acosf.jl")
include("binary32/asinf.jl")
include("binary32/atanf.jl")
include("binary32/atan2f.jl")

# Hyperbolic
# acosh
# asinh
# atanh
# cosh
# sinh
include("binary32/tanhf.jl")

# Power
include("binary32/rsqrt.jl")
include("binary32/rsqrtf.jl")

# Error and gamma
include("binary32/tgammaf.jl")
