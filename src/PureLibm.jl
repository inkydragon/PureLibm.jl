module PureLibm

include("utils/const.jl")
include("utils/error.jl")
include("utils/hint.jl")

# impl
include("openlibm/OpenLibm.jl")

end
