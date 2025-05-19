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

#= Trigonometric =#
include("acos.jl")
include("asin.jl")
include("atan.jl")
include("atan2.jl")
include("cos.jl")
include("sin.jl")
include("sincos.jl")
include("tan.jl")
include("acospi.jl")
include("asinpi.jl")
include("atanpi.jl")
include("atan2pi.jl")
include("cospi.jl")
include("sinpi.jl")
include("tanpi.jl")

#= Hyperbolic =#
include("acosh.jl")
include("asinh.jl")
include("atanh.jl")
include("cosh.jl")
include("sinh.jl")
include("tanh.jl")

#= Exponential and logarithmic =#
include("exp.jl")
include("exp10.jl")
include("exp10m1.jl")
include("exp2.jl")
include("exp2m1.jl")
include("expm1.jl")
include("log.jl")
include("log10.jl")
include("log10p1.jl")
include("log1p.jl")
# cr_logp1 = cr_log1p
include("log2.jl")
include("log2p1.jl")

#= Power and Absolute-value =#
include("cbrt.jl")
include("compoundn.jl")
include("hypot.jl")
include("pow.jl")
# pown
# powr
# rootn
include("rsqrt.jl")
include("sqrt.jl")

#= Error and gamma =#
include("erf.jl")
include("erfc.jl")
include("lgamma.jl")
include("tgamma.jl")

@testset "PureLibm.jl" begin
    # Write your tests here.
end
