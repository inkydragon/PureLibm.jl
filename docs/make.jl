using PureLibm
using Documenter

DocMeta.setdocmeta!(PureLibm, :DocTestSetup, :(using PureLibm); recursive=true)

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
        "Reference" => Any[
            "LLVM Libc [Apache]" => "ref/llvm-libc.md",
            "Core Math [MIT]" => "ref/core-math.md",
            "RLibm [MIT]" => "ref/rlibm.md",
            "Std C11" => "ref/std-c11.md",
            "Std C23" => "ref/std-c23.md",
        ],
    ],
)

deploydocs(;
    repo="github.com/inkydragon/PureLibm.jl",
    devbranch="main",
)
