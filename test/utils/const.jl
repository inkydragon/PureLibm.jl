# SPDX-License-Identifier: MIT OR Apache-2.0

"""Float32 [0.0, Inf]"""
const F32_POS_RANGE = (lo=+Float32(0.0), hi=+Float32(Inf))
"""Float32 [0.0, Inf)"""
const F32_POS_FINITE_RANGE = (lo=+Float32(0.0), hi=+prevfloat(Float32(Inf)))
"""Float32 [-Inf, -0.0]"""
const F32_NEG_RANGE = (lo=-Float32(0.0), hi=-Float32(Inf))
"""Float32 (-Inf, -0.0]"""
const F32_NEG_FINITE_RANGE = (lo=-Float32(0.0), hi=-prevfloat(Float32(Inf)))


function asfloat(u::UInt32)
    reinterpret(Float32, u)
end

"""
NO   Name           Hex         hex: %a             base2               base10
1    NaN (+max)     0x7fffffff  nan
2    NaN (+min)     0x7f800001  nan
3    Inf            0x7f800000  inf
4    Max Normal     0x7f7fffff  0x1.fffffep+127     (1-2^-24)×2^+128    3.403E+38
5    2              0x40000000  0x1p+1              2^1                 2.000E+00
6    Min Normal     0x00800000  0x1p-126            2^-126              1.175E-38
7    Max Subnormal  0x007fffff  0x1.fffffcp-127     (1-2^-23)×2^-126    1.175E-38
8    mid Subnormal  0x00400000  0x1p-127            2^-127              2.296E-41
9    Min Subnormal  0x00000001  0x1p-149            2^-149              1.401E-45
10  +0              0x00000000  0x0p+0              0                   0.000E+00

NO   Name           Hex          hex: %a             base2               base10
11  -0              0x80000000  -0x0p+0              0                   0.000E+00
12  -Min Subnormal  0x80000001  -0x1p-149           -2^-149             -1.401E-45
13  -mid Subnormal  0x80004000  -0x1p-135           -2^-127             -2.296E-41
14  -Max Subnormal  0x807fffff  -0x1.fffffcp-127    -(1-2^-23)×2^-126   -1.175E-38
15  -Min Normal     0x80800000  -0x1p-126           -2^-126             -1.175E-38
16  -2              0xc0000000  -0x1p+1             -2^1                -2.000E+00
17  -Max Normal     0xff7fffff  -0x1.fffffep+127    -(1-2^-24)×2^+128   -3.403E+38
18  -Inf            0xff800000  -inf
19   NaN (-min)     0xff800001   nan
20   NaN (-max)     0xffffffff   nan
"""

@testset "Float32  Const" begin
    # Different representations
    @test asfloat(PureLibm.F32_POS_ZERO) === Float32(0x0p+0)
    @test asfloat(PureLibm.F32_MIN_SUBNORMAL) === Float32(0x1p-149)
    @test asfloat(PureLibm.F32_MAX_SUBNORMAL) === Float32(0x1.fffffcp-127)
    @test asfloat(PureLibm.F32_MIN_NORMAL) === Float32(0x1p-126)
    @test asfloat(PureLibm.F32_MAX_NORMAL) === Float32(0x1.fffffep+127)
    @test asfloat(PureLibm.F32_MAX_FINITE) === Float32(0x1.fffffep+127)
    @test asfloat(PureLibm.F32_POS_INF) === Float32(+Inf)
    # NOTE: DoNot use `===` to compare NaN
    @test asfloat(PureLibm.F32_MIN_NAN) |> isnan
    @test asfloat(PureLibm.F32_MAX_NAN) |> isnan
end
