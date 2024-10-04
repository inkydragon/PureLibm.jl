module PureLibm

include("utils/const.jl")
include("utils/error.jl")
include("utils/hint.jl")

# impl
include("error-and-gamma/gamma.jl")
include("openlibm/OpenLibm.jl")

end
