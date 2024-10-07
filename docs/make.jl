using PureLibm
using Documenter

DocMeta.setdocmeta!(PureLibm, :DocTestSetup, :(using PureLibm); recursive=true)

libm_functions = Any[
    "math/index.md",

    # Trigonometric
    "math/acos.md",
    "math/asin.md",
    "math/atan.md",
    "math/atan2.md",
    # Power
    "math/sqrt.md",
    "math/cbrt.md",
]

makedocs(;
    modules=[PureLibm],
    authors="Chengyu HAN <git@wo-class.cn> and contributors",
    sitename="PureLibm.jl",
    format=Documenter.HTML(;
        canonical="https://inkydragon.github.io/PureLibm.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Math Functions" => libm_functions,
        "function-index.md",
        "docs.md",
        "Reference" => Any[
            "ref/index.md",
            "C Standards" => Any[
                # C std
                "ref/std-c99.md",
                "ref/std-c11.md",
                "ref/std-c23.md",
                # IEEE 754
                "IEEE 754" => "ref/ieee754.md",
            ],
            "Correctly Rounded" => Any[
                "LLVM Libc [Apache]" => "ref/llvm-libc.md",
                "Core Math [MIT]" => "ref/core-math.md",
                "RLibm [MIT]" => "ref/rlibm.md",
            ],
            # libm
            # "BSD Libm [BSD]" => "ref/bsd.md",
            "Zig [MIT]" => "ref/zig.md",
            # "AOCL-LibM [BSD-3]" => "ref/aocl.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/inkydragon/PureLibm.jl",
    devbranch="main",
)
