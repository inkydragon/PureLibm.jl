# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log10/log10f.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

#! format: off
# Keep same format as in log10f.c
const CR_LOG10F_TR = Vector{Float64}([
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
])
const CR_LOG10F_TL = Vector{Float64}([
    -0x1.d45fd6237ebe3p-47, 0x1.b947689311b6ep-8, 0x1.b5e909c96d7d5p-7, 0x1.45f4f59ed2165p-6,
    0x1.af5f92cbd8f1ep-6, 0x1.0ba01a606de8cp-5, 0x1.3ed119b9a2b7bp-5, 0x1.714834298eec2p-5,
    0x1.a30a9d98357fbp-5, 0x1.d41d512670813p-5, 0x1.02428c0f65519p-4, 0x1.1a23444eecc3ep-4,
    0x1.31b30543f4cb4p-4, 0x1.48f3ed39bfd04p-4, 0x1.5fe8049a0e423p-4, 0x1.769140a6aa008p-4,
    0x1.8cf1836c98cb3p-4, 0x1.a30a9d55541a1p-4, 0x1.b8de4d1ee823ep-4, 0x1.ce6e4202ca2e6p-4,
    0x1.e3bc1accace07p-4, 0x1.f8c9683b5abd4p-4, 0x1.06cbd68ca9a6ep-3, 0x1.11142f19df73p-3,
    0x1.1b3e71fa7a97fp-3, 0x1.254b4d37a46e3p-3, 0x1.2f3b6912cbf07p-3, 0x1.390f683115886p-3,
    0x1.42c7e7fffc5a8p-3, 0x1.4c65808c78d3cp-3, 0x1.55e8c50751c55p-3, 0x1.5f52445dec3d8p-3,
    0x1.68a288c3f12p-3, 0x1.71da17bdf0d19p-3, 0x1.7af973608afd9p-3, 0x1.84011952a2579p-3,
    0x1.8cf1837a7ea6p-3, 0x1.95cb2891e43d6p-3, 0x1.9e8e7b0f869ep-3, 0x1.a73beaa5db18dp-3,
    0x1.afd3e394558d3p-3, 0x1.b856cf060d9f1p-3, 0x1.c0c5134de1ffcp-3, 0x1.c91f1371bc99fp-3,
    0x1.d1652ffcd3f53p-3, 0x1.d997c6f635e75p-3, 0x1.e1b733ab90f3bp-3, 0x1.e9c3ceadac856p-3,
    0x1.f1bdeec43a305p-3, 0x1.f9a5e7a5fa3fep-3, 0x1.00be05ac02f2bp-2, 0x1.04a054d81a2d4p-2,
    0x1.087a0835957fbp-2, 0x1.0c4b457099517p-2, 0x1.101431aa1fe51p-2, 0x1.13d4f08b98dd8p-2,
    0x1.178da53edb892p-2, 0x1.1b3e71e9f9d58p-2, 0x1.1ee777defdeedp-2, 0x1.2288d7b48e23bp-2,
    0x1.2622b0f52e49fp-2, 0x1.29b522a4c6314p-2, 0x1.2d404b0e30f8p-2, 0x1.30c4478f3fbe5p-2,
    0x1.34413509f7915p-2
])
const CR_LOG10F_ST_F32 = NTuple{16, Float32}((
    0x1p+0, 0x1.4p+3, 0x1.9p+6, 0x1.f4p+9,
    0x1.388p+13, 0x1.86ap+16, 0x1.e848p+19, 0x1.312dp+23,
    0x1.7d784p+26, 0x1.dcd65p+29, 0x1.2a05f2p+33, 0,
    0, 0, 0, 0
))
const CR_LOG10F_ST = NTuple{16, UInt32}([
    reinterpret(UInt32, f32) for f32 in CR_LOG10F_ST_F32
])
const CR_LOG10F_B = NTuple{3, Float64}((
    0x1.bcb7b15c5a2f8p-2, -0x1.bcbb1dbb88ebap-3, 0x1.2871c39d521c6p-3
))
const CR_LOG10F_C = NTuple{7, Float64}((
    0x1.bcb7b1526e50ep-2, -0x1.bcb7b1526e53dp-3, 0x1.287a7636f3fa2p-3, -0x1.bcb7b146a14b3p-4,
    0x1.63c627d5219cbp-4, -0x1.2880736c8762dp-4, 0x1.fc1ecf913961ap-5
))
#! format: on

function _log10f_as_special(x::Float32)
    ux = reinterpret(UInt32, x)
    if ux == UInt32(0x7f800000)
        return x  # +inf
    end
    ax = ux << 1
    if ax == 0x00000000  # -0.0
        # errno = ERANGE
        # feraiseexcept(FE_DIVBYZERO)
        return -Inf32
    end
    if ax > UInt32(0xff000000)
        return x + x  # NaN
    end
    # errno = EDOM
    # feraiseexcept(FE_INVALID)
    return NaN32
end

"""
    cr_log10(x::Float32)

Correctly-rounded radix-10 logarithm function for binary32 value.

# Reference
-
"""
cr_log10(x::Float32) = cr_log10f(x)

function cr_log10f(x::Float32)
    ux = reinterpret(UInt32, x)
    if @unlikely(ux < (UInt32(1) << 23) || ux >= 0x7f800000)
        if ux == 0 || ux >= 0x7f800000
            return _log10f_as_special(x)
        end
        # subnormal
        n = Int32(_llvm_clz(ux) - 8)
        ux <<= n
        ux = reinterpret(UInt32, ux - (n << 23))
    end

    m = ux & ((UInt32(1) << 23) - 1)
    j = (m + (UInt32(1) << (23 - 7))) >> (23 - 6)
    ix = CR_LOG10F_TR[j+1]
    l = CR_LOG10F_TL[j+1]
    e = (reinterpret(Int32, ux) >> 23) - 127
    je = reinterpret(UInt32, Int32(e + 1))
    je = (je * 0x4d104d4) >> 28
    if @unlikely(ux == CR_LOG10F_ST[je+1])
        return Float32(je)
    end

    tzu = (Int64(m) | (Int64(1023) << 23)) << (52 - 23)
    tzf = reinterpret(Float64, tzu)
    z = tzf * ix - 1
    z2 = z * z
    b = CR_LOG10F_B
    r = ((e * 0x1.34413509f79ffp-2 + l) + z * b[1]) + z2 * (b[2] + z * b[3])
    ub = Float32(r)
    lb = Float32(r + 0x1.b008p-34)
    if @unlikely(ub != lb)
        c = CR_LOG10F_C
        f =
            z * (
                (c[1] + z * c[2]) +
                z2 * ((c[3] + z * c[4]) + z2 * (c[5] + z * c[6] + z2 * c[7]))
            )
        f -= 0x1.0cee0ed4ca7e9p-54 * e
        f += l - CR_LOG10F_TL[0+1]
        el = e * 0x1.34413509f7ap-2
        r = el + f
        ub = Float32(r)
        tzf = Float32(r)
        tzu = reinterpret(UInt32, tzf)
        if @unlikely(tzu & ((UInt32(1) << 28) - UInt32(1))) == 0
            dr = (el - r) + f
            r += dr * 32
            ub = Float32(r)
        end
    end

    return ub
end
