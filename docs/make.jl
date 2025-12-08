using PureLibm
using Documenter

DocMeta.setdocmeta!(PureLibm, :DocTestSetup, :(using PureLibm); recursive=true)

makedocs(;
    modules=[PureLibm],
    authors="Chengyu HAN <cyhan.dev@outlook.com> and contributors",
    sitename="PureLibm.jl",
    format=Documenter.HTML(;
        # canonical="https://inkydragon.github.io/PureLibm.jl",
        canonical="https://cyhan.dev/PureLibm.jl",
        edit_link="main",
        assets=String[],
    ),
    warnonly=true,
    checkdocs=:exports,
    pages=[
        "Home" => "index.md",
        "Reference" => Any[
            "reference/index.md",
            "reference/f32.md",
            "reference/f64.md"
        ],
        "Tech Notes" => Any[
            "notes/index.md",
            "C Standards" => Any[
                # C std
                "notes/std-c99.md",
                "notes/std-c11.md",
                "notes/std-c23.md",
                # IEEE 754
                "IEEE 754" => "notes/ieee754.md",
            ],
            "Correctly Rounded" => Any[
                "LLVM Libc [Apache]" => "notes/llvm-libc.md",
                "Core Math [MIT]" => "notes/core-math.md",
                "RLibm [MIT]" => "notes/rlibm.md",
            ],
        ],
    ],
)

deploydocs(;
    repo="github.com/inkydragon/PureLibm.jl",
    devbranch="main",
    push_preview = true,
)
