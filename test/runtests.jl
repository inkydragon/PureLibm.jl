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

# Trigonometric
include("acos.jl")
include("asin.jl")
include("atan.jl")
# atan2
include("cos.jl")
include("sin.jl")
include("sincos.jl")
include("tan.jl")
include("acospi.jl")
include("asinpi.jl")
include("atanpi.jl")
# atan2pi
include("cospi.jl")
include("sinpi.jl")
include("tanpi.jl")

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
include("log.jl")
include("log10.jl")
# log10p1
include("log1p.jl")
# logp1
include("log2.jl")
# log2p1

# Power and Absolute-value
include("cbrt.jl")
# compoundn
# hypot
# pow
include("rsqrt.jl")
include("sqrt.jl")

# Error and gamma
include("erf.jl")
include("erfc.jl")
include("lgamma.jl")
include("tgamma.jl")

@testset "PureLibm.jl" begin
    # Write your tests here.
end
