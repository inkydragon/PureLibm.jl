# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/tgamma/tgammaf.c
# CORE-MATH project Copyright (c) 2023-2025 Alexei Sibidanov.

#! format: off
"""
Lookup table for lgamma special cases.

Each entry is a tuple of `(bit_pattern, value, correction)`, where:

- `bit_pattern (.x.u)`: the UInt32 representation of the input,
- `value (.f)`: the main result (Float32),
- `correction (.df)`: a small adjustment (Float32).
"""
const CR_LGAMMAF_TB = Vector{Tuple{UInt32, Float32, Float32}}([
    # the entries of tb[] should be ordered by increasing .u value
    (reinterpret(UInt32, Float32(0x1.ecf3fep-73)), Float32(0x1.8f8e5ap+5), Float32(-0x1p-20)),
    (reinterpret(UInt32, Float32(0x1.108a5ap-66)), Float32(0x1.6d7b18p+5), Float32(-0x1p-20)),
    (reinterpret(UInt32, Float32(0x1.a68bbcp-42)), Float32(0x1.c9c6e8p+4), Float32(0x1p-21)),
    (reinterpret(UInt32, Float32(0x1.ddfd06p-12)), Float32(0x1.ec5ba8p+2), Float32(-0x1p-23)),
    (reinterpret(UInt32, Float32(0x1.f8a754p-9)), Float32(0x1.63acc2p+2), Float32(0x1p-23)),
    (reinterpret(UInt32, Float32(0x1.8d16b2p+5)), Float32(0x1.1e4b4ep+7), Float32(0x1p-18)),
    (reinterpret(UInt32, Float32(0x1.359e0ep+10)), Float32(0x1.d9ad02p+12), Float32(-0x1p-13)),
    (reinterpret(UInt32, Float32(0x1.a82a2cp+13)), Float32(0x1.c38036p+16), Float32(0x1p-9)),
    (reinterpret(UInt32, Float32(0x1.62c646p+14)), Float32(0x1.9075bep+17), Float32(-0x1p-8)),
    (reinterpret(UInt32, Float32(0x1.7f298p+31)), Float32(0x1.f44946p+35), Float32(-0x1p+10)),
    (reinterpret(UInt32, Float32(0x1.a45ea4p+33)), Float32(0x1.25dcbcp+38), Float32(-0x1p+13)),
    (reinterpret(UInt32, Float32(0x1.f9413ep+76)), Float32(0x1.9d5ab4p+82), Float32(-0x1p+57)),
    (reinterpret(UInt32, Float32(0x1.dcbbaap+99)), Float32(0x1.fc5772p+105), Float32(0x1p+80)),
    (reinterpret(UInt32, Float32(0x1.58ace8p+112)), Float32(0x1.9e4f66p+118), Float32(-0x1p+93)),
    (reinterpret(UInt32, Float32(0x1.87bdfp+115)), Float32(0x1.e465aep+121), Float32(0x1p+96)),
    (reinterpret(UInt32, Float32(-0x1.25cb66p-123)), Float32(0x1.547a44p+6), Float32(-0x1p-19)),
    (reinterpret(UInt32, Float32(-0x1.ecf3fep-73)), Float32(0x1.8f8e5ap+5), Float32(-0x1p-20)),
    (reinterpret(UInt32, Float32(-0x1.108a5ap-66)), Float32(0x1.6d7b18p+5), Float32(-0x1p-20)),
    (reinterpret(UInt32, Float32(-0x1.f51c8ep-49)), Float32(0x1.0a572ap+5), Float32(-0x1p-20)),
    (reinterpret(UInt32, Float32(-0x1.d85bfep-43)), Float32(0x1.d31592p+4), Float32(-0x1p-21)),
    (reinterpret(UInt32, Float32(-0x1.437e74p-40)), Float32(0x1.b7dec2p+4), Float32(-0x1p-21)),
    (reinterpret(UInt32, Float32(-0x1.ade594p-30)), Float32(0x1.446ab2p+4), Float32(-0x1p-21)),
    (reinterpret(UInt32, Float32(-0x1.c2f04p-30)), Float32(0x1.43a6f6p+4), Float32(0x1p-21)),
    (reinterpret(UInt32, Float32(-0x1.580c1ep+1)), Float32(-0x1.5787c6p-4), Float32(0x1p-29)),
    (reinterpret(UInt32, Float32(-0x1.69d628p+3)), Float32(-0x1.0eac2ap+4), Float32(-0x1p-21)),
    (reinterpret(UInt32, Float32(-0x1.627346p+7)), Float32(-0x1.73235ep+9), Float32(-0x1p-16)),
    (reinterpret(UInt32, Float32(-0x1.efc2a2p+14)), Float32(-0x1.222dbcp+18), Float32(-0x1p-7)),
])
#! format: on

function _lgam_as_r7(x::Float64, c::NTuple{7,Float64})::Float64
    return ((x - c[1]) * (x - c[2])) *
           ((x - c[3]) * (x - c[4])) *
           (((x - c[5]) * (x - c[6])) * (x - c[7]))
end

function _lgam_as_r8(x::Float64, c::NTuple{8,Float64})::Float64
    return ((x - c[1]) * (x - c[2])) *
           ((x - c[3]) * (x - c[4])) *
           (((x - c[5]) * (x - c[6])) * ((x - c[7]) * (x - c[8])))
end

"""
Approximation of `sin(πx)` on [0,1] using an even polynomial after shifting `x → x - 0.5`.
Used in reflection terms for negative `x` when evaluating `lgamma`.
"""
function _lgam_as_sinpi(x::Float64)::Float64
    c = NTuple{8, Float64}((
        0x1p+2, -0x1.de9e64df22ea4p+1, 0x1.472be122401f8p+0, -0x1.d4fcd82df91bp-3,
        0x1.9f05c97e0aab2p-6, -0x1.f3091c427b611p-10, 0x1.b22c9bfdca547p-14, -0x1.15484325ef569p-18,
    ))

    x -= 0.5
    x2 = x * x
    x4 = x2 * x2
    x8 = x4 * x4
    return (0.25 - x2) * (
        (c[1] + x2 * c[2]) +
        x4 * (c[3] + x2 * c[4]) +
        x8 * ((c[5] + x2 * c[6]) + x4 * (c[7] + x2 * c[8]))
    )
end

"""
Core `ln(x)` with 4-bit table-based range reduction and an 8-term polynomial.
Provides a fast, accurate backbone for large-`x` `lgamma` asymptotics and reflection.
"""
function _lgam_as_ln(x::Float64)::Float64
    tu = reinterpret(UInt64, x)
    e = trunc(Int, (tu >> 52)) - 0x3ff

    c = NTuple{8, Float64}((
        0x1.fffffffffff24p-1, -0x1.ffffffffd1d67p-2, 0x1.55555537802dep-2, -0x1.ffffeca81b866p-3,
        0x1.999611761d772p-3, -0x1.54f3e581b61bfp-3, 0x1.1e642b4cb5143p-3, -0x1.9115a5af1e1edp-4,
    ))
    il = NTuple{16, Float64}((
        0x1.59caeec280116p-57, 0x1.f0a30c01162aap-5, 0x1.e27076e2af2ebp-4, 0x1.5ff3070a793d6p-3,
        0x1.c8ff7c79a9a2p-3, 0x1.1675cababa60fp-2, 0x1.4618bc21c5ec2p-2, 0x1.739d7f6bbd007p-2,
        0x1.9f323ecbf984dp-2, 0x1.c8ff7c79a9a21p-2, 0x1.f128f5faf06ecp-2, 0x1.0be72e4252a83p-1,
        0x1.1e85f5e7040d1p-1, 0x1.307d7334f10bep-1, 0x1.41d8fe84672afp-1, 0x1.52a2d265bc5abp-1,
    ))
    ix = NTuple{16, Float64}((
        0x1p+0, 0x1.e1e1e1e1e1e1ep-1, 0x1.c71c71c71c71cp-1, 0x1.af286bca1af28p-1,
        0x1.999999999999ap-1, 0x1.8618618618618p-1, 0x1.745d1745d1746p-1, 0x1.642c8590b2164p-1,
        0x1.5555555555555p-1, 0x1.47ae147ae147bp-1, 0x1.3b13b13b13b14p-1, 0x1.2f684bda12f68p-1,
        0x1.2492492492492p-1, 0x1.1a7b9611a7b96p-1, 0x1.1111111111111p-1, 0x1.0842108421084p-1,
    ))

    i = Int((tu >> 48) & UInt64(0x0f)) + 1
    tu = (tu & ((~UInt64(0)) >> 12)) | (UInt64(0x3ff) << 52)
    tf = reinterpret(Float64, tu)
    z = ix[i] * tf - 1.0
    z2 = z * z
    z4 = z2 * z2
    return e * 0x1.62e42fefa39efp-1 +
           il[i] +
           z * (
               (c[1] + z * c[2]) +
               z2 * (c[3] + z * c[4]) +
               z4 * ((c[5] + z * c[6]) + z2 * (c[7] + z * c[8]))
           )
end

"""
    cr_lgamma(x::Float32)

Correctly-rounded logarithm of the absolute value of the gamma function for `Float32`.

# Examples
```jldoctest
julia> PureLibm.cr_lgamma(1.0f0)
0.0f0

julia> PureLibm.cr_lgamma(2.0f0)
0.0f0

julia> PureLibm.cr_lgamma(3.0f0)
0.6931472f0

julia> PureLibm.cr_lgamma(0.0f0)
Inf32

julia> PureLibm.cr_lgamma.(Float32[0.5, 1, 1.5, 2, 3, 10])
6-element Vector{Float32}:
  0.5723649
  0.0
 -0.12078224
  0.0
  0.6931472
 12.801827

julia> PureLibm.cr_lgamma(Inf32)
Inf32

julia> PureLibm.cr_lgamma.(Float32[-0.0, -1, -2, -3, -10, -Inf])
6-element Vector{Float32}:
 Inf
 Inf
 Inf
 Inf
 Inf
 Inf
```

# Reference
- [core-math/src/binary32/lgamma/lgammaf.c](https://github.com/inkydragon/core-math/blob/062fb094d9137bc7cb057f20dc372078df4b3292/src/binary32/lgamma/lgammaf.c)
"""
cr_lgamma(x::Float32) = cr_lgammaf(x)

function cr_lgammaf(x::Float32)::Float32
    # NOTE: `signgam` is specified in POSIX.1-2001, but not in C99.
    signgam = 0
    fx = floor(x)
    ax = abs(x)

    tu = reinterpret(UInt32, ax)
    if @unlikely(tu >= (UInt32(0xff) << 23))
        # NaN or Inf
        if tu == (UInt32(0xff) << 23)
            signgam = 1
            # +-inf
            return 1.0f0 / 0.0f0
        end

        # NaN
        return x + x
    end

    if @unlikely(fx == x)
        # x integer
        if x <= 0.0f0
            tu = reinterpret(UInt32, x)
            if (tu << 1) != 1
                signgam = 1 - 2 * (tu >> 31)
            end

            #= gamma(+0) = +Inf, gamma(-0) = -Inf =#
            # errno = ERANGE
            return 1.0f0 / 0.0f0
        end

        if x == 1.0f0 || x == 2.0f0
            signgam = 1
            return 0.0f0
        end
    end

    #=
        Check the value of fx to avoid a spurious invalid exception.
        Note that for a binary32 |x| >= 2^23, x is necessarily an integer,
        and we already dealed with negative integers, thus now:
        -2^23 < x < +Inf and x is not a negative integer nor 0, 1, 2.
    =#
    if @likely(fx >= 0)
        signgam = 1
    else
        # gamma(x) is negative in (-2n-1,-2n), thus when fx is odd
        signgam = 1 - ((trunc(Int, fx) & 1) << 1)
    end

    z = Float64(ax)
    f = 0.0
    s = Float64(x)
    if @unlikely(ax < Float32(0x1.52p-1))
        # |x| < 0.66015625f0
        rn = NTuple{8, Float64}((
            -0x1.505bdf4b65acp+4, -0x1.51c80eb47e068p+2, 0x1.0000000007cb8p+0, -0x1.4ac529250a1fcp+1,
            -0x1.a8c99dbe1621ap+0, -0x1.4abdcc74115eap+0, -0x1.1b87fe5a5b923p+0, -0x1.05b8a4d47ff64p+0,
        ))
        c0 = 0x1.0fc0fad268c4dp+2
        rd = NTuple{8, Float64}((
            -0x1.4db2cfe9a5265p+5, -0x1.062e99d1c4f27p+3, -0x1.c81bc2ecf25f6p+1, -0x1.108e55c10091bp+1,
            -0x1.7dd25af0b83d4p+0, -0x1.36bf1880125fcp+0, -0x1.1379fc8023d9cp+0, -0x1.03712e41525d2p+0,
        ))
        f = (c0 * s) * _lgam_as_r8(s, rn) / _lgam_as_r8(s, rd) - _lgam_as_ln(z)
    else
        # |x| >= 0.66015625f0
        if ax > Float32(0x1.afc1ap+1)
            # |x| > 3.3730965f0
            if @unlikely(x >= Float32(0x1.895f1cp+121))
                # x >= 4.0850034f36
                #=
                    for x=0x1.895f1cp+121, lgamma(x) < 2^128, thus there is no
                    overflow for rounding towards zero or downwards.
                    The following expression overflows for x > 0x1.895f1cp+121
                    or x = 0x1.895f1cp+121 and rounding to nearest or away,
                    and does not overflow for x = 0x1.895f1cp+121 and rounding
                    towards zero
                =#
                r = fma(x, Float32(0x1.4d3398p+6), Float32(0x1.10f35ep+103))
                # if (x > Float32(0x1.895f1cp+121)
                #     || (x == Float32(0x1.895f1cp+121)
                #         && x * 5.0f0 >= Float32(0x1.ebb6e4p+123)))
                #     errno = ERANGE  # overflow
                # end
                return r
            end

            # 3.3730965f0 < |x| and x < 4.0850034f36
            #   (-Inf, -3.3730965f0) and (3.3730965f0, 4.0850034f36)
            lz = _lgam_as_ln(z)
            f = (z - 0.5) * (lz - 1.0) + 0x1.acfe390c97d69p-2
            if ax < Float32(0x1.0p+20)
                # 3.3730965f0 < |x| < 1.048576f6
                iz = 1.0 / z
                iz2 = iz * iz
                if ax > 1198.0f0
                    # 1198.0f0 < |x| < 1.048576f6
                    f += iz * (1.0 / 12.0)
                elseif ax > Float32(0x1.279a7p+6)
                    # 73.90082f0 < |x| <= 1198.0f0
                    c = NTuple{2,Float64}((0x1.555555547fbadp-4, -0x1.6c0fd270c465p-9))
                    f += iz * (c[1] + iz2 * c[2])
                elseif ax > Float32(0x1.555556p+3)
                    # 10.666667f0 < |x| <= 73.90082f0
                    c = NTuple{4, Float64}((0x1.555555554de0bp-4, -0x1.6c16bdc45944fp-9, 0x1.a0077f300ecb3p-11, -0x1.2e9cfff3b29c2p-11))
                    iz4 = iz2 * iz2
                    f += iz * ((c[1] + iz2 * c[2]) + iz4 * (c[3] + iz2 * c[4]))
                else
                    # 3.3730965f0 < |x| <= 10.666667f0
                    c = NTuple{8, Float64}((
                        0x1.5555555551286p-4, -0x1.6c16c0e7c4cf4p-9, 0x1.a0193267fe6f2p-11, -0x1.37e87ec19cb45p-11,
                        0x1.b40011dfff081p-11, -0x1.c16c8946b19b6p-10, 0x1.e9f47ace150d8p-9, -0x1.4f5843a71a338p-8,
                    ))
                    iz4 = iz2 * iz2
                    iz8 = iz4 * iz4
                    p =
                        ((c[1] + iz2 * c[2]) + iz4 * (c[3] + iz2 * c[4])) +
                        iz8 * ((c[5] + iz2 * c[6]) + iz4 * (c[7] + iz2 * c[8]))
                    f += iz * p
                end
            end
            if x < 0.0f0
                # x in (-Inf, -3.3730965f0)
                f = 0x1.250d048e7a1bdp+0 - f - lz
                lp = _lgam_as_ln(_lgam_as_sinpi(Float64(x - fx)))
                f -= lp
            end
        else
            # 0.66015625f0 <= |x| <= 3.3730965f0
            rn = NTuple{7, Float64}((
                -0x1.667923ff14df7p+5, -0x1.2d35f25ad8f64p+3, -0x1.b8c9eab9d5bd3p+1, -0x1.7a4a97f494127p+0,
                -0x1.3a6c8295b4445p-1, -0x1.da44e8b810024p-3, -0x1.9061e81c77e4ap-5,
            ))
            c0 = 0x1.3cc0e6a0106b3p+2
            rd = NTuple{8, Float64}((
                -0x1.491a899e84c52p+6, -0x1.d202961b9e098p+3, -0x1.4ced68c631ed6p+2, -0x1.2589eedf40738p+1,
                -0x1.1302e3337271p+0, -0x1.c36b802f26dffp-2, -0x1.3ded448acc39dp-3, -0x1.bffc491078eafp-6,
            ))
            f = (z - 1.0) * (z - 2.0) * c0 * _lgam_as_r7(z, rn) / _lgam_as_r8(z, rd)
            if x < 0.0f0
                # x in (-3.3730965f0, -0.66015625f0)
                if @unlikely(tu < 0x40301b93 && tu > 0x402f95c2)
                    # |x| in (2.7435155f0, 2.751683f0)
                    h = (s + 0x1.5fb410a1bd901p+1) - 0x1.a19a96d2e6f85p-54
                    h2 = h * h
                    h4 = h2 * h2
                    c = NTuple{8, Float64}((
                        -0x1.ea12da904b18cp+0, 0x1.3267f3c265a54p+3, -0x1.4185ac30cadb3p+4, 0x1.f504accc3f2e4p+5,
                        -0x1.8588444c679b4p+7, 0x1.43740491dc22p+9, -0x1.12400ea23f9e6p+11, 0x1.dac829f365795p+12,
                    ))
                    f =
                        h * (
                            (c[1] + h * c[2]) +
                            h2 * (c[3] + h * c[4]) +
                            h4 * ((c[5] + h * c[6]) + h2 * (c[7] + h * c[8]))
                        )
                elseif @unlikely(tu > 0x401ceccb && tu < 0x401d95ca)
                    # |x| in (2.4519527f0, 2.4622674f0)
                    h = (s + 0x1.3a7fc9600f86cp+1) + 0x1.55f64f98af8dp-55
                    h2 = h * h
                    h4 = h2 * h2
                    c = NTuple{7, Float64}((
                        0x1.83fe966af535fp+0, 0x1.36eebb002f61ap+2, 0x1.694a60589a0b3p+0, 0x1.1718d7aedb0b5p+3,
                        0x1.733a045eca0d3p+2, 0x1.8d4297421205bp+4, 0x1.7feea5fb29965p+4,
                    ))
                    f =
                        h * (
                            (c[1] + h * c[2]) +
                            h2 * (c[3] + h * c[4]) +
                            h4 * ((c[5] + h * c[6]) + h2 * (c[7]))
                        )
                elseif @unlikely(tu > 0x40492009 && tu < 0x404940ef)
                    # |x| in (3.1425803f0, 3.1445882f0)
                    h = (s + 0x1.9260dbc9e59afp+1) + 0x1.f717cd335a7b3p-53
                    h2 = h * h
                    h4 = h2 * h2
                    c = NTuple{7, Float64}((
                        0x1.f20a65f2fac55p+2, 0x1.9d4d297715105p+4, 0x1.c1137124d5b21p+6, 0x1.267203d24de38p+9,
                        0x1.99a63399a0b44p+11, 0x1.2941214faaf0cp+14, 0x1.bb912c0c9cdd1p+16,
                    ))
                    f =
                        h * (
                            (c[1] + h * c[2]) +
                            h2 * (c[3] + h * c[4]) +
                            h4 * ((c[5] + h * c[6]) + h2 * (c[7]))
                        )
                else
                    # log(pi)
                    ln_pi = 0x1.250d048e7a1bdp+0
                    f = ln_pi - f
                    lp = _lgam_as_ln(_lgam_as_sinpi(Float64(x - fx)) * z)
                    f -= lp
                end
            end
        end
    end

    rtu = reinterpret(UInt64, f)
    tl = (rtu + UInt64(5)) & UInt64(0x0fffffff)
    r = Float32(f)
    if @unlikely(tl <= UInt64(31))
        tu = reinterpret(UInt32, x)
        tb = CR_LGAMMAF_TB
        a = 1
        b = length(tb) + 1
        #= invariant: t.u < tb[1].x.u or tb[a].x.u <= t.u < tb[b].x.u =#
        while (a + 1) < b
            i = (a + b) ÷ 2
            if tu < tb[i][1]
                b = i
            else
                a = i
            end
        end
        if tu == tb[a][1]
            return tb[a][2] + tb[a][3]
        end
    end

    return r
end
