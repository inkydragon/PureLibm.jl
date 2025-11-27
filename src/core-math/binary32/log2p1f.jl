# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log2p1/log2p1f.c
# CORE-MATH project Copyright (c) 2022-2025 Alexei Sibidanov.

#! format: off
const CR_LOG2P1F_IX = NTuple{129, Float64}((
    0x1p+0, 0x1.fc07f01fcp-1, 0x1.f81f81f82p-1, 0x1.f44659e4ap-1, 0x1.f07c1f07cp-1,
    0x1.ecc07b302p-1, 0x1.e9131abfp-1, 0x1.e573ac902p-1, 0x1.e1e1e1e1ep-1,
    0x1.de5d6e3f8p-1, 0x1.dae6076bap-1, 0x1.d77b654b8p-1, 0x1.d41d41d42p-1,
    0x1.d0cb58f6ep-1, 0x1.cd8568904p-1, 0x1.ca4b3055ep-1, 0x1.c71c71c72p-1,
    0x1.c3f8f01c4p-1, 0x1.c0e070382p-1, 0x1.bdd2b8994p-1, 0x1.bacf914c2p-1,
    0x1.b7d6c3ddap-1, 0x1.b4e81b4e8p-1, 0x1.b2036406cp-1, 0x1.af286bca2p-1,
    0x1.ac5701ac6p-1, 0x1.a98ef606ap-1, 0x1.a6d01a6dp-1, 0x1.a41a41a42p-1,
    0x1.a16d3f97ap-1, 0x1.9ec8e951p-1, 0x1.9c2d14ee4p-1, 0x1.99999999ap-1,
    0x1.970e4f80cp-1, 0x1.948b0fcd6p-1, 0x1.920fb49dp-1, 0x1.8f9c18f9cp-1,
    0x1.8d3018d3p-1, 0x1.8acb90f6cp-1, 0x1.886e5f0acp-1, 0x1.861861862p-1,
    0x1.83c977ab2p-1, 0x1.818181818p-1, 0x1.7f405fd02p-1, 0x1.7d05f417ep-1,
    0x1.7ad2208ep-1, 0x1.78a4c8178p-1, 0x1.767dce434p-1, 0x1.745d1745ep-1,
    0x1.724287f46p-1, 0x1.702e05c0cp-1, 0x1.6e1f76b44p-1, 0x1.6c16c16c2p-1,
    0x1.6a13cd154p-1, 0x1.681681682p-1, 0x1.661ec6a52p-1, 0x1.642c8590cp-1,
    0x1.623fa7702p-1, 0x1.605816058p-1, 0x1.5e75bb8dp-1, 0x1.5c9882b94p-1,
    0x1.5ac056b02p-1, 0x1.58ed23082p-1, 0x1.571ed3c5p-1, 0x1.555555556p-1,
    0x1.5390948f4p-1, 0x1.51d07eae2p-1, 0x1.501501502p-1, 0x1.4e5e0a73p-1,
    0x1.4cab88726p-1, 0x1.4afd6a052p-1, 0x1.49539e3b2p-1, 0x1.47ae147aep-1,
    0x1.460cbc7f6p-1, 0x1.446f86562p-1, 0x1.42d6625d6p-1, 0x1.414141414p-1,
    0x1.3fb013fbp-1, 0x1.3e22cbce4p-1, 0x1.3c995a47cp-1, 0x1.3b13b13b2p-1,
    0x1.3991c2c18p-1, 0x1.381381382p-1, 0x1.3698df3dep-1, 0x1.3521cfb2cp-1,
    0x1.33ae45b58p-1, 0x1.323e34a2cp-1, 0x1.30d19013p-1, 0x1.2f684bda2p-1,
    0x1.2e025c04cp-1, 0x1.2c9fb4d82p-1, 0x1.2b404ad02p-1, 0x1.29e4129e4p-1,
    0x1.288b01288p-1, 0x1.27350b882p-1, 0x1.25e22708p-1, 0x1.24924924ap-1,
    0x1.23456789ap-1, 0x1.21fb78122p-1, 0x1.20b470c68p-1, 0x1.1f7047dc2p-1,
    0x1.1e2ef3b4p-1, 0x1.1cf06ada2p-1, 0x1.1bb4a4046p-1, 0x1.1a7b9611ap-1,
    0x1.19453808cp-1, 0x1.181181182p-1, 0x1.16e068942p-1, 0x1.15b1e5f76p-1,
    0x1.1485f0e0ap-1, 0x1.135c81136p-1, 0x1.12358e75ep-1, 0x1.111111112p-1,
    0x1.0fef010fep-1, 0x1.0ecf56be6p-1, 0x1.0db20a89p-1, 0x1.0c9714fbcp-1,
    0x1.0b7e6ec26p-1, 0x1.0a6810a68p-1, 0x1.0953f3902p-1, 0x1.084210842p-1,
    0x1.073260a48p-1, 0x1.0624dd2f2p-1, 0x1.05197f7d8p-1, 0x1.041041042p-1,
    0x1.03091b52p-1, 0x1.020408102p-1, 0x1.01010101p-1, 0x1p-1
))

const CR_LOG2P1F_LIX = NTuple{129, Float64}((
    0x0p+0, -0x1.6fe50b6f1eafap-7, -0x1.6e79685c160d5p-6, -0x1.11cd1d51955bap-5,
    -0x1.6bad37591e03p-5, -0x1.c4dfab908ddb5p-5, -0x1.0eb389fab4795p-4, -0x1.3aa2fdd26ae99p-4,
    -0x1.663f6faca846bp-4, -0x1.918a16e4cb157p-4, -0x1.bc84240a78a13p-4, -0x1.e72ec1181cfb1p-4,
    -0x1.08c588cd964e4p-3, -0x1.1dcd19759f2e3p-3, -0x1.32ae9e27627c6p-3, -0x1.476a9f989a58ap-3,
    -0x1.5c01a39fa6533p-3, -0x1.70742d4eed455p-3, -0x1.84c2bd02d6434p-3, -0x1.98edd077e9f0ap-3,
    -0x1.acf5e2db31eeap-3, -0x1.c0db6cddaa82dp-3, -0x1.d49ee4c33121ap-3, -0x1.e840be751d775p-3,
    -0x1.fbc16b9003e0bp-3, -0x1.0790adbae3fcp-2, -0x1.11307dad465b5p-2, -0x1.1ac05b2924cc5p-2,
    -0x1.24407ab0cc41p-2, -0x1.2db10fc4ea424p-2, -0x1.37124cea58697p-2, -0x1.406463b1d455dp-2,
    -0x1.49a784bcbaa37p-2, -0x1.52dbdfc4f341dp-2, -0x1.5c01a39ff2c9bp-2, -0x1.6518fe46abaa5p-2,
    -0x1.6e221cd9d6933p-2, -0x1.771d2ba7f5791p-2, -0x1.800a56315ee2ap-2, -0x1.88e9c72df8611p-2,
    -0x1.91bba891d495fp-2, -0x1.9a8023920fa4dp-2, -0x1.a33760a7fbca6p-2, -0x1.abe18797d2effp-2,
    -0x1.b47ebf734b923p-2, -0x1.bd0f2e9eb2b84p-2, -0x1.c592fad2be1aap-2, -0x1.ce0a4923cf5e6p-2,
    -0x1.d6753e02f4ebcp-2, -0x1.ded3fd445afp-2, -0x1.e726aa1e558fep-2, -0x1.ef6d67325ba38p-2,
    -0x1.f7a8568c8aea6p-2, -0x1.ffd799a81be87p-2, 0x1.f804ae8d33c4p-2, 0x1.efec61b04af4ep-2,
    0x1.e7df5fe572606p-2, 0x1.dfdd89d5b0009p-2, 0x1.d7e6c0abbd924p-2, 0x1.cffae611a74d6p-2,
    0x1.c819dc2d8578cp-2, 0x1.c043859e5bdbcp-2, 0x1.b877c57b47c04p-2, 0x1.b0b67f4f29a66p-2,
    0x1.a8ff97183ed07p-2, 0x1.a152f14293c74p-2, 0x1.99b072a9289cap-2, 0x1.921800927e284p-2,
    0x1.8a8980ac4113p-2, 0x1.8304d90c2859dp-2, 0x1.7b89f02cbd49ap-2, 0x1.7418aceb84ab1p-2,
    0x1.6cb0f68656c95p-2, 0x1.6552b49993dc2p-2, 0x1.5dfdcf1eacd7bp-2, 0x1.56b22e6b97c18p-2,
    0x1.4f6fbb2ce6943p-2, 0x1.48365e6957b42p-2, 0x1.4106017c0dbcfp-2, 0x1.39de8e15727d9p-2,
    0x1.32bfee37489bcp-2, 0x1.2baa0c34989c3p-2, 0x1.249cd2b177fd5p-2, 0x1.1d982c9d50468p-2,
    0x1.169c0536677acp-2, 0x1.0fa848045f67bp-2, 0x1.08bce0d9a7c6p-2, 0x1.01d9bbcf66a2cp-2,
    0x1.f5fd8a90e2d85p-3, 0x1.e857d3d3af1e5p-3, 0x1.dac22d3ec5f4ep-3, 0x1.cd3c712db459ap-3,
    0x1.bfc67a7ff3c22p-3, 0x1.b2602497678f4p-3, 0x1.a5094b555a1f8p-3, 0x1.97c1cb136b96fp-3,
    0x1.8a8980ac8652dp-3, 0x1.7d60496c83f66p-3, 0x1.7046031c7cdafp-3, 0x1.633a8bf460335p-3,
    0x1.563dc2a08b102p-3, 0x1.494f863bbc1dep-3, 0x1.3c6fb6507a37ep-3, 0x1.2f9e32d5257ecp-3,
    0x1.22dadc2a627efp-3, 0x1.1625931802e49p-3, 0x1.097e38cef9519p-3, 0x1.f9c95dc138295p-4,
    0x1.e0b1ae90505f6p-4, 0x1.c7b528b5fcffap-4, 0x1.aed391abb17a1p-4, 0x1.960caf9bd35eap-4,
    0x1.7d60496e3edebp-4, 0x1.64ce26bf2108ep-4, 0x1.4c560fe5b573bp-4, 0x1.33f7cde24adfbp-4,
    0x1.1bb32a5ed9353p-4, 0x1.0387efbd3006ep-4, 0x1.d6ebd1f1d0955p-5, 0x1.a6f9c37a8beabp-5,
    0x1.77394c9d6762cp-5, 0x1.47aa07358e1a4p-5, 0x1.184b8e4d490efp-5, 0x1.d23afc4d95c78p-6,
    0x1.743ee8678a7cbp-6, 0x1.16a21e243bf78p-6, 0x1.72c7ba20c907ep-7, 0x1.720d9c0536e17p-8,
    0x0p+0
))

const CR_LOG2P1F_C2 = NTuple{2, Float64}((
    0x1.71547652b82fep+0, -0x1.71547652b82ffp-1,
))

const CR_LOG2P1F_C4 = NTuple{4, Float64}((
    0x1.71547652b82fep+0, -0x1.71547652b82fdp-1, 0x1.ec709ead0c9a7p-2, -0x1.7154773c1cb29p-2,
))

const CR_LOG2P1F_C6 = NTuple{6, Float64}((
    0x1.71547652b82fep+0, -0x1.71547652b83p-1, 0x1.ec709dc28f51bp-2, -0x1.7154765157748p-2,
    0x1.2778a510a3682p-2, -0x1.ec745df1551fcp-3,
))

const CR_LOG2P1F_C8 = NTuple{8, Float64}((
    0x1.71547652b82fep+0, -0x1.71547652b82fbp-1, 0x1.ec709dc3b6a73p-2, -0x1.71547652dc09p-2,
    0x1.2776c1a88901p-2, -0x1.ec7095bd4d208p-3, 0x1.a66bec7fc8f7p-3, -0x1.71a900fc3f3f9p-3,
))

const CR_LOG2P1F_CB = NTuple{6, Float64}((
    0x1.71547652b82fep+0, -0x1.71547652b82ffp-1, 0x1.ec709dc32988bp-2, -0x1.715476521ec2bp-2,
    0x1.277801a1ad904p-2, -0x1.ec731704d6a88p-3,
))
#! format: on

"""
    cr_log2p1(x::Float32)

Correctly-rounded `log2(1+x)` function for `Float32`.

# Examples
```jldoctest
julia> PureLibm.cr_log2p1.((0.0f0, -0.0f0))
(0.0f0, -0.0f0)

julia> PureLibm.cr_log2p1(1.0f0)
1.0f0

julia> PureLibm.cr_log2p1(3.0f0)
2.0f0

julia> PureLibm.cr_log2p1(-0.5f0)
-1.0f0

julia> PureLibm.cr_log2p1(-1.0f0)
-Inf32
```

# Reference
- [core-math/src/binary32/log2p1/log2p1f.c](https://github.com/inkydragon/core-math/blob/9f7bf82f5abdf032f3a4733e97ee4a8069bdbed6/src/binary32/log2p1/log2p1f.c)
"""
cr_log2p1(x::Float32) = cr_log2p1f(x)

function cr_log2p1f(x::Float32)::Float32
    z = Float64(x)
    ux = reinterpret(UInt32, x)
    ax = ux & (~UInt32(0) >> 1)
    if @unlikely(ux >= (UInt32(0x17f) << 23))
        # x <= -1.0f0
        if ux == (UInt32(0x17f) << 23)
            # errno = ERANGE
            # log2p1(-1.0f0) = -Inf32
            return -1.0f0 / 0.0f0
        end
        if ux > (UInt32(0x1ff) << 23)
            # log2p1(NaN) = NaN
            return x + x
        end
        # errno = EDOM
        # log2p1(-Inf) = NaN
        return NaN32
    elseif @unlikely(ax >= (UInt32(0xff) << 23))
        # +inf, nan
        if ax > (UInt32(0xff) << 23)
            # log2p1(NaN) = NaN
            return x + x
        end
        # log2p1(Inf) = Inf
        return 1.0f0 / 0.0f0
    elseif @likely(ax < 0x3cb7aa26)
        # |x| < 0x1.6f544cp-6 == 0.02242f0
        z2 = z * z
        z4 = z2 * z2
        if @likely(ax < 0x3b9d9d34)
            # |x| < 0x1.3b3a68p-8 == 0.00481f0
            if @likely(ax < 0x39638a7e)
                # |x| < 0x1.c714fcp-13 == 0.000217f0
                if @likely(ax < 0x329c5639)
                    # |x| < 0x1.38ac72p-26 == 1.82f-8
                    c = CR_LOG2P1F_C2
                    res = z * (c[1] + z * c[2])
                    # if (x != 0 && abs(res) < 0x1p-126)
                    #     errno = ERANGE  # underflow
                    # end
                    return Float32(res)
                else
                    # x in [1.82f-8, 0.000217f0)
                    if @unlikely(ux == 0x32ff7045)
                        # x = 2.9736961f-8
                        return Float32(0x1.70851ap-25) - Float32(0x1.8p-80)
                    end
                    if @unlikely(ux == 0xb395efbb)
                        # x= -6.98196f-8
                        return Float32(-0x1.b0a00ap-24) + Float32(0x1p-76)
                    end
                    if @unlikely(ux == 0x35a14df7)
                        # x = 1.2018126f-6
                        return Float32(0x1.d16d2p-20) + Float32(0x1p-72)
                    end
                    if @unlikely(ux == 0x3841cb81)
                        # x = 4.6204314f-5
                        return Float32(0x1.17949ep-14) + Float32(0x1p-67)
                    end
                    c = CR_LOG2P1F_C4
                    return Float32(z * ((c[1] + z * c[2]) + z2 * (c[3] + z * c[4])))
                end
            else
                # x in [0.000217f0, 0.00481f0)
                if @unlikely(ux == 0xbac9363d)
                    # x = -0.0015351247f0
                    return Float32(-0x1.2282aap-9) + Float32(0x1p-61)
                end
                c = CR_LOG2P1F_C6
                return Float32(
                    z *
                    ((c[1] + z * c[2]) + z2 * (c[3] + z * c[4]) + z4 * (c[5] + z * c[6])),
                )
            end
        else
            # x in [0.00481f0, 0.02242f0)
            c = CR_LOG2P1F_C8
            return Float32(
                z * (
                    (c[1] + z * c[2]) +
                    z2 * (c[3] + z * c[4]) +
                    z4 * ((c[5] + z * c[6]) + z2 * (c[7] + z * c[8]))
                ),
            )
        end
    else
        # |x| >= 0x1.6f544cp-6 == 0.02242f0 and x > -1
        #   x in (-1, -0.02242f0] and [0.02242f0, +Inf)
        #=
            On cfarm117 with gcc 6.3.0, if we return 0x1.e90026p+4f + 0x1.fp-21
            in the second exceptional case, with rounding up it yields 0x1.e90026p+4
            which is incorrect, thus we use this workaround.
            See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=112367.
        =#
        if @unlikely(ux == 0x52928e33)
            # x = 3.1472547f11
            return Float32(0x1.318ffap+5) + Float32(0x1.fp-20)
        end
        if @unlikely(ux == 0x4ebd09e3)
            # x = 1.5857709f9
            return Float32(0x1.e90026p+4) + Float32(0x1.fp-21)
        end

        tpf = z + 1.0
        tpu = reinterpret(UInt64, tpf)
        m = tpu & (~UInt64(0) >> 12)
        e = trunc(Int, tpu >> 52) - 0x3ff
        j = trunc(Int, (m + (UInt64(1) << (52 - 8))) >> (52 - 7))
        k = j > 53 ? 1 : 0
        e += k

        xdu = m | (UInt64(0x3ff) << 52)
        xdf = reinterpret(Float64, xdu)
        z = fma(xdf, CR_LOG2P1F_IX[j+1], -1.0)
        c = CR_LOG2P1F_CB
        z2 = z * z
        c0 = c[1] + z * c[2]
        c2 = c[3] + z * c[4]
        c4 = c[5] + z * c[6]
        c0 += z2 * (c2 + z2 * c4)
        r = (z * c0 - CR_LOG2P1F_LIX[j+1]) + e

        return Float32(r)
    end
end
