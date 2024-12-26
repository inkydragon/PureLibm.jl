module PureLibm

include("utils/const.jl")
include("utils/llvm_intrinsics.jl")
include("utils/hint.jl")

# impl
include("core-math/CoreMath.jl")

include("doc.jl")

end
