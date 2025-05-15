# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/atanh/atanhf.c
# CORE-MATH project Copyright (c) 2023-2025 Alexei Sibidanov.

#! format: off
# Keep same format as in atanhf.c
"""
Calculate atanh(x) using the difference of two logarithms --
atanh(x) = (ln(1+x) - ln(1-x))/2
"""
const CR_ATANHF_TR = Vector{Float64}([
    0x1.fc07f02p-1, 0x1.f44659ep-1, 0x1.ecc07b3p-1, 0x1.e573ac9p-1,
    0x1.de5d6e4p-1, 0x1.d77b655p-1, 0x1.d0cb58fp-1, 0x1.ca4b305p-1,
    0x1.c3f8f02p-1, 0x1.bdd2b8ap-1, 0x1.b7d6c3ep-1, 0x1.b20364p-1,
    0x1.ac5701bp-1, 0x1.a6d01a7p-1, 0x1.a16d3f9p-1, 0x1.9c2d14fp-1,
    0x1.970e4f8p-1, 0x1.920fb4ap-1, 0x1.8d3018dp-1, 0x1.886e5f1p-1,
    0x1.83c977bp-1, 0x1.7f405fdp-1, 0x1.7ad2209p-1, 0x1.767dce4p-1,
    0x1.724287fp-1, 0x1.6e1f76bp-1, 0x1.6a13cd1p-1, 0x1.661ec6ap-1,
    0x1.623fa77p-1, 0x1.5e75bb9p-1, 0x1.5ac056bp-1, 0x1.571ed3cp-1,
    0x1.5390949p-1, 0x1.5015015p-1, 0x1.4cab887p-1, 0x1.49539e4p-1,
    0x1.460cbc8p-1, 0x1.42d6626p-1, 0x1.3fb014p-1, 0x1.3c995a4p-1,
    0x1.3991c2cp-1, 0x1.3698df4p-1, 0x1.33ae45bp-1, 0x1.30d1901p-1,
    0x1.2e025cp-1, 0x1.2b404adp-1, 0x1.288b013p-1, 0x1.25e2271p-1,
    0x1.2345679p-1, 0x1.20b470cp-1, 0x1.1e2ef3bp-1, 0x1.1bb4a4p-1,
    0x1.1945381p-1, 0x1.16e0689p-1, 0x1.1485f0ep-1, 0x1.12358e7p-1,
    0x1.0fef011p-1, 0x1.0db20a9p-1, 0x1.0b7e6ecp-1, 0x1.0953f39p-1,
    0x1.073260ap-1, 0x1.05197f8p-1, 0x1.03091b5p-1, 0x1.010101p-1
])
const CR_ATANHF_TL = Vector{Float64}([
    0x1.fe02a69106789p-9, 0x1.7b91b1155b11bp-7, 0x1.39e87ba1ebd6p-6, 0x1.b42dd713971bfp-6,
    0x1.16536ee637ae1p-5, 0x1.51b073c96183fp-5, 0x1.8c345da019b21p-5, 0x1.c5e5492abc743p-5,
    0x1.fec912fbbeabbp-5, 0x1.1b72ad33f67ap-4, 0x1.371fc1f6e8f74p-4, 0x1.526e5e5a1b438p-4,
    0x1.6d60fe601d21dp-4, 0x1.87fa06438c911p-4, 0x1.a23bc223ab563p-4, 0x1.bc28673a58cd6p-4,
    0x1.d5c216b8fbb91p-4, 0x1.ef0adcaec5936p-4, 0x1.040259530d041p-3, 0x1.1058bf8d24ad5p-3,
    0x1.1c898c09d99fbp-3, 0x1.2895a13e286a3p-3, 0x1.347dd9a447d55p-3, 0x1.404308716a7e4p-3,
    0x1.4be5f963b78a1p-3, 0x1.5767718015a6cp-3, 0x1.62c82f3a5c795p-3, 0x1.6e08eab13a1e4p-3,
    0x1.792a55fe147a2p-3, 0x1.842d1d9928b17p-3, 0x1.8f11e873a62c7p-3, 0x1.99d958207e08bp-3,
    0x1.a484090c1bb0ap-3, 0x1.af129324b786bp-3, 0x1.b9858970710fbp-3, 0x1.c3dd7a6ddad4dp-3,
    0x1.ce1af0b65f3ebp-3, 0x1.d83e725022f3ep-3, 0x1.e2488197c6c26p-3, 0x1.ec399d3d68ccp-3,
    0x1.f6123fac028acp-3, 0x1.ffd2e07e7f498p-3, 0x1.04bdf9e3b26d2p-2, 0x1.0986f4fa93521p-2,
    0x1.0e4498651cc8cp-2, 0x1.12f719595efbcp-2, 0x1.179eabb0a99a1p-2, 0x1.1c3b81e933c25p-2,
    0x1.20cdcd0e0ab6ep-2, 0x1.2555bcf50f7cbp-2, 0x1.29d37ff34b08bp-2, 0x1.2e47437640268p-2,
    0x1.32b1338401d71p-2, 0x1.37117b5c147b6p-2, 0x1.3b6844a13fc23p-2, 0x1.3fb5b857f6f42p-2,
    0x1.43f9fe2f7ce67p-2, 0x1.48353d11488dfp-2, 0x1.4c679b014ee3ap-2, 0x1.50913cc03686bp-2,
    0x1.54b2468259498p-2, 0x1.58cadb57d7989p-2, 0x1.5cdb1dcaa1765p-2, 0x1.60e32f46788d9p-2
])
const CR_ATANHF_LN2N = Vector{Float64}([
    0x1.62e42fedb2a44p-2, 0x1.62e42feeab21ap-1, 0x1.0a2b23f33e789p+0, 0x1.62e42fef27604p+0,
    0x1.bb9d3beb1048p+0, 0x1.0a2b23f37c97ep+1, 0x1.3687a9f1710bcp+1, 0x1.62e42fef657fap+1,
    0x1.8f40b5ed59f38p+1, 0x1.bb9d3beb4e676p+1, 0x1.e7f9c1e942db4p+1, 0x1.0a2b23f39ba79p+2,
    0x1.205966f295e18p+2, 0x1.3687a9f1901b7p+2, 0x1.4cb5ecf08a556p+2, 0x1.62e42fef848f5p+2,
    0x1.791272ee7ec93p+2, 0x1.8f40b5ed79032p+2, 0x1.a56ef8ec733d1p+2, 0x1.bb9d3beb6d77p+2,
    0x1.d1cb7eea67b0fp+2, 0x1.e7f9c1e961eaep+2, 0x1.fe2804e85c24dp+2, 0x1.0a2b23f3ab2f6p+3
])
const CR_ATANHF_B = NTuple{3, Float64}((
    0x1.fffffffce5a6ap-2, -0x1.0001f81ec0ab8p-2, 0x1.555a0f53d79a5p-3
))
const CR_ATANHF_C1 = NTuple{4, Float64}((
    0x1.5555555555527p-2, 0x1.9999999ba4ee8p-3, 0x1.24922c280990ap-3, 0x1.c8236aae809c6p-4
))
const CR_ATANHF_C2 = NTuple{7, Float64}((
    0x1p-1, -0x1.000000000001bp-2, 0x1.55555555555bap-3,-0x1.fffffff26d72ep-4,
    0x1.99999989035p-4, -0x1.555c39cb9ee8p-4, 0x1.24992d8b014a1p-4
))
#! format: on

function _atanhf_as_special(x::Float32)
    ux = reinterpret(UInt32, x)
    ax = ux << 1
    if ax == 0x7f000000
        # +-1
        # errno = ERANGE
        return x / 0.0f0  # raise FE_DIVBYZERO
    end
    if ax > 0xff000000
        return x + x  # NaN
    end
    # errno = EDOM
    return 0.0f0 / 0.0f0  # raise FE_INVALID
end

"""
Correctly-rounded inverse hyperbolic tangent of `Float32`.
"""
function cr_atanhf(x::Float32)
    ux = reinterpret(UInt32, x)
    ax = ux << 1
    if (ax < 0x7a300000 || ax >= 0x7f000000)
        # |x| < 0x1.5a3116p-5 or x is NaN/Inf
        if (ax >= 0x7f000000)
            # NaN/Inf
            return _atanhf_as_special(x)
        end
        if (ax < 0x73713744)
            # |x| < 0x1.f5a956p-12
            if ax == 0
                # x = +-0
                return x
            end
            # errno = ERANGE
            # |x| < 0.000352112(0x1.713744p-12)
            return fma(x, Float32(0x1p-25), x)
        else
            # |x| < 0x1.3p-5
            z = Float64(x)
            z2 = z * z
            z4 = z2 * z2
            c = CR_ATANHF_C1
            r = c[1] + z2 * c[2] + z4 * (c[3] + z2 * c[4])
            return Float32(z + z * z2 * r)
        end
    end

    s = (1.0, -1.0)
    sgn = s[(ux>>31)+1]
    e = UInt32(ax >> 24)
    md = UInt32(((ux << 8) | (UInt32(1) << 31)) >> (126 - e))
    mn = UInt32(-md)
    nz = _llvm_clz(mn) + 1
    mn <<= nz
    jn = mn >> 26
    jd = md >> 26

    tn = reinterpret(Float64, (Int64(mn) << 20) | (Int64(1023) << 52))
    td = reinterpret(Float64, (Int64(md) << 20) | (Int64(1023) << 52))
    tr = CR_ATANHF_TR
    zn = tn * tr[jn+1] - 1
    zd = td * tr[jd+1] - 1
    zn2 = zn * zn
    zd2 = zd * zd

    tl = CR_ATANHF_TL
    b = CR_ATANHF_B
    rn = (tl[jn+1] - CR_ATANHF_LN2N[nz]) + zn * b[1] + zn2 * (b[2] + zn * b[3])
    rd = tl[jd+1] + zd * b[1] + zd2 * (b[2] + zd * b[3])
    r = sgn * (rd - rn)

    ub = Float32(r)
    lb = Float32(r + sgn * 0.226e-9)
    if (ub != lb)
        zn4 = zn2^2
        zd4 = zd2^2
        c = CR_ATANHF_C2
        fn =
            zn * (
                (c[1] + zn * c[2]) +
                zn2 * (c[3] + zn * c[4]) +
                zn4 * (c[5] + zn * c[6] + zn2 * c[7])
            )
        fn += 0x1.0ca86c3898dp-50 * nz
        fn += tl[jn+1]
        en = nz * 0x1.62e42fefa3ap-2
        fd =
            zd * (
                (c[1] + zd * c[2]) +
                zd2 * (c[3] + zd * c[4]) +
                zd4 * (c[5] + zd * c[6] + zd2 * c[7])
            )
        fd += tl[jd+1]
        r = fd - fn + en
        ub = Float32(sgn * r)
    end

    return ub
end
