using PureLibm
using Test

include("utils/const.jl")

# C99: Trigonometric
include("acos.jl")
include("asin.jl")
include("atan.jl")
# atan2
# cos
# sin
# tan

# C99: Hyperbolic
# acosh
# asinh
# atanh
# cosh
# sinh
# tanh

# C99: Exponential and logarithmic
# exp
# exp2
# expm1 
# log10
# log1p
# log2
# log

# C99: Power and Absolute-value
# pow
include("sqrt.jl")
include("cbrt.jl")
# hypot

# C99: Error and gamma
# erf
# erfc
# lgamma
# tgamma

@testset "PureLibm.jl" begin
    # Write your tests here.
end
