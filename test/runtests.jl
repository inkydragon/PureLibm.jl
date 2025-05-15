using PureLibm
using Test
using Printf

# TODO: copy tests to LibmTest.jl

"""
Running Exhaustive tests for `Float32`.
"""
const CheckExhaustive = if haskey(ENV, "PURELIBM_CHECK_EXHAUSTIVE")
    Set(strip.(split(ENV["PURELIBM_CHECK_EXHAUSTIVE"], ",")))
else
    Set{String}()
end


include("utils/const.jl")
include("utils/llvm_intrinsics.jl")
include("utils/ranges.jl")

# C99: Trigonometric
include("acos.jl")
include("asin.jl")
include("atan.jl")
# atan2
include("cos.jl")
include("sin.jl")
include("sinpi.jl")
include("sincos.jl")
include("tan.jl")

# C99: Hyperbolic
include("acosh.jl")
include("asinh.jl")
include("atanh.jl")
include("cosh.jl")
include("sinh.jl")
include("tanh.jl")

# Exponential and logarithmic
include("exp.jl")
include("exp10.jl")
include("exp2.jl")
include("expm1.jl")
# log10
include("log1p.jl")
# log2
include("log.jl")

# C99: Power and Absolute-value
# pow
include("sqrt.jl")
include("rsqrt.jl")
include("cbrt.jl")
# hypot

# C99: Error and gamma
# erf
# erfc
# lgamma
include("tgamma.jl")

@testset "PureLibm.jl" begin
    # Write your tests here.
end
