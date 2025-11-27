# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log10p1/log10p1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

#! format: off
const CR_LOG10P1F_LOG10_2 = 0x1.34413509f79ffp-2
const CR_LOG10P1F_LB_DELTA = 0x1.5cp-42

# tr and tl tables
const CR_LOG10P1F_TR = NTuple{65, Float64}((
    0x1p+0, 0x1.f81f82p-1, 0x1.f07c1fp-1, 0x1.e9131acp-1,
    0x1.e1e1e1ep-1, 0x1.dae6077p-1, 0x1.d41d41dp-1, 0x1.cd85689p-1,
    0x1.c71c71cp-1, 0x1.c0e0704p-1, 0x1.bacf915p-1, 0x1.b4e81b5p-1,
    0x1.af286bdp-1, 0x1.a98ef6p-1, 0x1.a41a41ap-1, 0x1.9ec8e95p-1,
    0x1.999999ap-1, 0x1.948b0fdp-1, 0x1.8f9c19p-1, 0x1.8acb90fp-1,
    0x1.8618618p-1, 0x1.8181818p-1, 0x1.7d05f41p-1, 0x1.78a4c81p-1,
    0x1.745d174p-1, 0x1.702e05cp-1, 0x1.6c16c17p-1, 0x1.6816817p-1,
    0x1.642c859p-1, 0x1.605816p-1, 0x1.5c9882cp-1, 0x1.58ed231p-1,
    0x1.5555555p-1, 0x1.51d07ebp-1, 0x1.4e5e0a7p-1, 0x1.4afd6ap-1,
    0x1.47ae148p-1, 0x1.446f865p-1, 0x1.4141414p-1, 0x1.3e22cbdp-1,
    0x1.3b13b14p-1, 0x1.3813814p-1, 0x1.3521cfbp-1, 0x1.323e34ap-1,
    0x1.2f684bep-1, 0x1.2c9fb4ep-1, 0x1.29e412ap-1, 0x1.27350b9p-1,
    0x1.2492492p-1, 0x1.21fb781p-1, 0x1.1f7047ep-1, 0x1.1cf06aep-1,
    0x1.1a7b961p-1, 0x1.1811812p-1, 0x1.15b1e5fp-1, 0x1.135c811p-1,
    0x1.1111111p-1, 0x1.0ecf56cp-1, 0x1.0c9715p-1, 0x1.0a6810ap-1,
    0x1.0842108p-1, 0x1.0624dd3p-1, 0x1.041041p-1, 0x1.0204081p-1,
    0.5
))

const CR_LOG10P1F_TL = NTuple{65, Float64}((
    -0x1.562ec497ef351p-43, 0x1.b9476892ea99cp-8, 0x1.b5e909c959eecp-7, 0x1.45f4f59ec84fp-6,
    0x1.af5f92cbcf2aap-6, 0x1.0ba01a6069052p-5, 0x1.3ed119b99dd41p-5, 0x1.714834298a088p-5,
    0x1.a30a9d98309c1p-5, 0x1.d41d51266b9d9p-5, 0x1.02428c0f62dfcp-4, 0x1.1a23444eea521p-4,
    0x1.31b30543f2597p-4, 0x1.48f3ed39bd5e7p-4, 0x1.5fe8049a0bd06p-4, 0x1.769140a6a78eap-4,
    0x1.8cf1836c96595p-4, 0x1.a30a9d5551a84p-4, 0x1.b8de4d1ee5b21p-4, 0x1.ce6e4202c7bc9p-4,
    0x1.e3bc1accaa6eap-4, 0x1.f8c9683b584b7p-4, 0x1.06cbd68ca86ep-3, 0x1.11142f19de3a2p-3,
    0x1.1b3e71fa795fp-3, 0x1.254b4d37a3354p-3, 0x1.2f3b6912cab79p-3, 0x1.390f6831144f7p-3,
    0x1.42c7e7fffb21ap-3, 0x1.4c65808c779aep-3, 0x1.55e8c507508c7p-3, 0x1.5f52445deb049p-3,
    0x1.68a288c3efe72p-3, 0x1.71da17bdef98bp-3, 0x1.7af9736089c4bp-3, 0x1.84011952a11ebp-3,
    0x1.8cf1837a7d6d1p-3, 0x1.95cb2891e3048p-3, 0x1.9e8e7b0f85651p-3, 0x1.a73beaa5d9dfep-3,
    0x1.afd3e39454544p-3, 0x1.b856cf060c662p-3, 0x1.c0c5134de0c6dp-3, 0x1.c91f1371bb611p-3,
    0x1.d1652ffcd2bc5p-3, 0x1.d997c6f634ae6p-3, 0x1.e1b733ab8fbadp-3, 0x1.e9c3ceadab4c8p-3,
    0x1.f1bdeec438f77p-3, 0x1.f9a5e7a5f906fp-3, 0x1.00be05ac02564p-2, 0x1.04a054d81990cp-2,
    0x1.087a083594e33p-2, 0x1.0c4b457098b4fp-2, 0x1.101431aa1f48ap-2, 0x1.13d4f08b98411p-2,
    0x1.178da53edaecbp-2, 0x1.1b3e71e9f9391p-2, 0x1.1ee777defd526p-2, 0x1.2288d7b48d874p-2,
    0x1.2622b0f52dad8p-2, 0x1.29b522a4c594cp-2, 0x1.2d404b0e305b9p-2, 0x1.30c4478f3f21dp-2,
    0x1.34413509f6f4dp-2
))

# sentinel inputs st (as Float32 values)
const CR_LOG10P1F_ST = NTuple{8, Float32}((
    Float32(0x0p+0), Float32(0x1.2p+3), Float32(0x1.8cp+6), Float32(0x1.f38p+9),
    Float32(0x1.3878p+13), Float32(0x1.869fp+16), Float32(0x1.e847ep+19), Float32(0x1.312cfep+23)
))

const CR_LOG10P1F_H = NTuple{4, Float64}((
    0x1.bcb7b150bf6d8p-2, -0x1.bcb7b1738c07ep-3, 0x1.287de19e795c5p-3, -0x1.bca44edc44bc4p-4
))

const CR_LOG10P1F_C_SMALL = NTuple{4, Float64}((
    0x1.bcb7b1526e50fp-1, 0x1.287a76370129dp-2, 0x1.63c62378fa3dbp-3, 0x1.fca4139a42374p-4
))

const CR_LOG10P1F_C_MAIN = NTuple{7, Float64}((
    0x1.bcb7b1526e50ep-2, -0x1.bcb7b1526e53dp-3, 0x1.287a7636f3fa2p-3, -0x1.bcb7b146a14b3p-4,
    0x1.63c627d5219cbp-4, -0x1.2880736c8762dp-4, 0x1.fc1ecf913961ap-5
))
#! format: on

"""
Handle special cases for `cr_log10p1f`.
"""
function _log10p1f_as_special(x::Float32)
    ux = reinterpret(UInt32, x)
    if ux == 0x7f800000
        # log10p1(Inf32) == Inf32
        return x
    end

    ax = ux << 1
    if ux == 0xbf800000
        # x = -1.0f0
        # errno = ERANGE
        # log10p1(-1.0f0) == -Inf32
        return -Inf32
    end
    if ax > 0xff000000
        # log10p1(NaN32) == NaN32
        return x + x
    end

    # errno = EDOM
    # feraiseexcept(FE_INVALID)
    return NaN32
end

"""
    cr_log10p1(x::Float32)

Correctly-rounded biased argument base-10 logarithm function for `Float32`.

# Examples
```jldoctest
julia> PureLibm.cr_log10p1(0.0f0)
0.0f0

julia> PureLibm.cr_log10p1(9.0f0)
1.0f0

julia> PureLibm.cr_log10p1(999.0f0)
3.0f0

julia> PureLibm.cr_log10p1(Inf32)
Inf32

julia> PureLibm.cr_log10p1(-1.0f0)
-Inf32
```

# Reference
- [core-math/src/binary32/log10p1/log10p1f.c](https://github.com/inkydragon/core-math/blob/7c7afc5d93cc3af4ff584f40f4a20af71488122a/src/binary32/log10p1/log10p1f.c)
"""
cr_log10p1(x::Float32) = cr_log10p1f(x)

function cr_log10p1f(x::Float32)
    ux = reinterpret(UInt32, x)
    if @unlikely(ux >= (UInt32(0x17f) << 23))
        # x <= -1
        return _log10p1f_as_special(x)
    end
    ax = ux & (typemax(UInt32) >> 1)
    if @unlikely(ax == 0x00000000)
        # log10p1(+-0.0f0) == +-0.0f0
        return copysign(0.0f0, x)
    end
    if @unlikely(ax >= (UInt32(0xff) << 23))
        # +inf, nan
        return _log10p1f_as_special(x)
    end

    ie = ux >> 23
    je = (ie - UInt32(126))
    je = trunc(UInt32, (UInt64(je) * 0x9a209a8) >> 29)
    idx = Int(je) + 1
    # @assert 1 <= idx && idx <= length(CR_LOG10P1F_ST)
    if @unlikely(1 <= idx
        && idx <= length(CR_LOG10P1F_ST)
        && (x == CR_LOG10P1F_ST[idx]))
        return Float32(je)
    end

    z = Float64(x)
    tzf = z + 1.0
    tzu = reinterpret(UInt64, tzf)
    m = tzu & (typemax(UInt64) >> 12)
    e = trunc(Int32, Int64(tzu >> 52) - 1023)
    j = trunc(Int32, (m + (UInt64(1) << 45)) >> 46)
    tzu = m | (UInt64(0x3ff) << 52)
    tzf = reinterpret(Float64, tzu)
    ix = CR_LOG10P1F_TR[j+1]
    l = CR_LOG10P1F_TL[j+1]
    v = tzf * ix - 1.0
    off = Float64(e) * CR_LOG10P1F_LOG10_2 + l

    v2 = v * v
    f =
        (CR_LOG10P1F_H[1] + v * CR_LOG10P1F_H[2]) +
        v2 * (CR_LOG10P1F_H[3] + v * CR_LOG10P1F_H[4])
    r = off + v * f

    ub = Float32(r)
    lb = Float32(r + CR_LOG10P1F_LB_DELTA)
    if @unlikely(ub != lb)
        if ax < 0x3d32743e
            # |x| < 0.04356789f0 (0x1.64e87cp-5f)
            if @unlikely(ux == 0xa6aba8af)
                # x = -1.191123f-15
                return Float32(-0x1.2a33bcp-51 + 0x1p-76)
            end
            if @unlikely(ux == 0xaf39b9a7)
                # x = -1.6891609f-10
                return Float32(-0x1.42a342p-34 + 0x1p-59)
            end
            if @unlikely(ux == 0x399a7c00)
                # x = 0.00029465556f0
                return Float32(0x1.0c53cap-13 + 0x1p-38)
            end

            z /= 2.0 + z
            z2 = z * z
            z4 = z2 * z2
            h = CR_LOG10P1F_C_SMALL
            r = z * ((h[1] + z2 * h[2]) + z4 * (h[3] + z2 * h[4]))
            # if (abs(r) < 0x1p-126)
            #     errno = ERANGE  # underflow
            # end
            return Float32(r)
        end

        # |x| >= 0.04356789f0
        if @unlikely(ux == 0x7956ba5e)
            # x = 6.968322f34
            return Float32(0x1.16bebap+5 + 0x1p-20)
        end
        if @unlikely(ux == 0xbd86ffb9)
            # x = -0.06591744f0
            return Float32(-0x1.e53536p-6 + 0x1p-31)
        end

        c = CR_LOG10P1F_C_MAIN
        f =
            v * (
                (c[1] + v * c[2]) +
                v2 * ((c[3] + v * c[4]) + v2 * (c[5] + v * c[6] + v2 * c[7]))
            )
        f += l - CR_LOG10P1F_TL[1]
        el = Float64(e) * CR_LOG10P1F_LOG10_2
        r = el + f
        ub = Float32(r)
        # tzu = reinterpret(UInt64, Float64(r))  # unused
    end

    return ub
end
