# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/log1p/log1pf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

const CR_LOG1PF_LIXB = NTuple{32, Float64}((
    0x1.fc0a8909b4218p-7, 0x1.77458f51aac89p-5, 0x1.341d793afb997p-4, 0x1.a926d3a5ebd2ap-4,
    0x1.0d77e7a8a823dp-3, 0x1.44d2b6c557102p-3, 0x1.7ab89040accecp-3, 0x1.af3c94ecab3d6p-3,
    0x1.e27076d54e6c9p-3, 0x1.0a324e3888ad5p-2, 0x1.22941fc0c7357p-2, 0x1.3a64c56ae3fdbp-2,
    0x1.51aad874af21fp-2, 0x1.686c81d300ea0p-2, 0x1.7eaf83c7fa9b5p-2, 0x1.947941aa610ecp-2,
    0x1.a9cec9a3f023bp-2, 0x1.beb4d9ea4156ep-2, 0x1.d32fe7f35e5c7p-2, 0x1.e7442617b817ap-2,
    0x1.faf588dd5ed10p-2, 0x1.0723e5c635c39p-1, 0x1.109f39d53c990p-1, 0x1.19ee6b38a4668p-1,
    0x1.23130d7f93c3bp-1, 0x1.2c0e9ec9b0b85p-1, 0x1.34e289cb35eccp-1, 0x1.3d9026ad3d3f3p-1,
    0x1.4618bc1eadbbbp-1, 0x1.4e7d8127dd8a9p-1, 0x1.56bf9d5967092p-1, 0x1.5ee02a926936ep-1
))

const CR_LOG1PF_X0 = NTuple{32, Float64}((
    0x1.f81f820p-1, 0x1.e9131acp-1, 0x1.dae6077p-1, 0x1.cd85689p-1,
    0x1.c0e0704p-1, 0x1.b4e81b5p-1, 0x1.a98ef60p-1, 0x1.9ec8e95p-1,
    0x1.948b0fdp-1, 0x1.8acb90fp-1, 0x1.8181818p-1, 0x1.78a4c81p-1,
    0x1.702e05cp-1, 0x1.6816817p-1, 0x1.6058160p-1, 0x1.58ed231p-1,
    0x1.51d07ebp-1, 0x1.4afd6a0p-1, 0x1.446f865p-1, 0x1.3e22cbdp-1,
    0x1.3813814p-1, 0x1.323e34ap-1, 0x1.2c9fb4ep-1, 0x1.27350b9p-1,
    0x1.21fb781p-1, 0x1.1cf06aep-1, 0x1.1811812p-1, 0x1.135c811p-1,
    0x1.0ecf56cp-1, 0x1.0a6810ap-1, 0x1.0624dd3p-1, 0x1.0204081p-1
))

const CR_LOG1PF_LIX = NTuple{32, Float64}((
    0x1.fc0a890fc03e4p-7, 0x1.77458f532dcfcp-5, 0x1.341d793bbd1d1p-4, 0x1.a926d3a6ad563p-4,
    0x1.0d77e7a908e59p-3, 0x1.44d2b6c5b7d1ep-3, 0x1.7ab890410d909p-3, 0x1.af3c94ed0bff3p-3,
    0x1.e27076d5af2e6p-3, 0x1.0a324e38b90e3p-2, 0x1.22941fc0f7966p-2, 0x1.3a64c56b145eap-2,
    0x1.51aad874df82dp-2, 0x1.686c81d3314afp-2, 0x1.7eaf83c82afc3p-2, 0x1.947941aa916fbp-2,
    0x1.a9cec9a42084ap-2, 0x1.beb4d9ea71b7cp-2, 0x1.d32fe7f38ebd5p-2, 0x1.e7442617e8788p-2,
    0x1.faf588dd8f31fp-2, 0x1.0723e5c64df40p-1, 0x1.109f39d554c97p-1, 0x1.19ee6b38bc96fp-1,
    0x1.23130d7fabf43p-1, 0x1.2c0e9ec9c8e8cp-1, 0x1.34e289cb4e1d3p-1, 0x1.3d9026ad556fbp-1,
    0x1.4618bc1ec5ec2p-1, 0x1.4e7d8127f5bb1p-1, 0x1.56bf9d597f399p-1, 0x1.5ee02a9281675p-1
))

const CR_LOG1PF_C = NTuple{5, Float64}((
    -0x1.3902c33434e7fp-43, 0x1.ffffffe1cbed5p-1,
    -0x1.ffffff7d1b014p-2, 0x1.5564e0ed3613ap-2,
    -0x1.0012232a00d4ap-2
))

const CR_LOG1PF_B = NTuple{8, Float64}((
    0x1p+0, -0x1p-1,
    0x1.5555555556f6bp-2, -0x1.00000000029b9p-2,
    0x1.9999988d176e4p-3, -0x1.55555418889a7p-3,
    0x1.24adeca50e2bcp-3, -0x1.001ba33bf57cfp-3
))


function _log1pf_as_special(x::Float32)
    tu = reinterpret(UInt32, x)
    if tu == 0xbf800000  # -1.0
        # errno = ERANGE
        return -Inf32  # to raise FE_DIVBYZERO
    elseif tu == 0x7f800000  # +Inf
        return x
    end
    ax = tu << 1
    if ax > 0xff000000
        return x + x  # NaN
    end
    # errno = EDOM
    return NaN32  # to raise FE_INVALID
end

"""
Correctly-rounded biased argument natural logarithm function for `Float32`.
"""
function cr_log1pf(x::Float32)::Float32
    z = Float64(x)
    ux = reinterpret(UInt32, x)
    ax = ux & (~UInt32(0) >> 1)
    if @likely(ax < 0x3c880000)  # |x| < 0.016601562f0
        if @unlikely(ax < 0x33000000)  # |x| < 2.9802322f-8
            if ax == 0
                return x
            end
            return fma(x, -x, x)
        end
        z2 = z * z
        z4 = z2 * z2
        b = CR_LOG1PF_B
        f = z2 * (
            (b[2] + z * b[3])
            + z2 * (b[4] + z * b[5])
            + z4 * ((b[6] + z * b[7]) + z2 * b[8]))
        rf = z + f
        ru = reinterpret(UInt64, rf)
        if @unlikely((ru & UInt64(0x0fff_ffff)) == 0)
            rf += 0x1p14 * (f + (z - rf))
        end
        return Float32(rf)
    else
        if ux >= 0xbf800000 || ax >= 0x7f800000
            return _log1pf_as_special(x)
        end

        tpf = z + 1.0
        tpu = reinterpret(UInt64, tpf)
        e = Int32(tpu >> 52)
        m52 = UInt64(tpu & (~UInt64(0) >> 12))
        j = Int((tpu >> (52-5)) & 31)
        e -= 0x3ff
        xdu = m52 | (UInt64(0x3ff) << 52)
        xdf = reinterpret(Float64, xdu)

        z = xdf * CR_LOG1PF_X0[j+1] - 1.0
        ln2 = 0x1.62e42fefa39efp-1
        z2 = z * z
        c = CR_LOG1PF_C
        r = ((ln2 * e + CR_LOG1PF_LIXB[j+1])
            + z * ((c[2] + z * c[3])
            + z2 * (c[4] + z * c[5])))
        ub = Float32(r)
        lb = Float32(r + 2.2e-11)
        if @unlikely(ub != lb)
            ln2l = 0x1.7f7d1cf79abcap-20
            ln2h = 0x1.62e4p-1
            z4 = z2 * z2
            b = CR_LOG1PF_B
            f = z * (
                (b[1] + z*b[2])
                + z2*(b[3] + z*b[4])
                + z4*((b[5] + z*b[6]) + z2*(b[7] + z*b[8])))
            Lh = ln2h * e
            Ll = ln2l * e
            rl = f + Ll + CR_LOG1PF_LIX[j+1]
            trf = rl + Lh
            tru = reinterpret(UInt64, trf)
            if @unlikely((tru & UInt64(0x0fff_ffff)) == 0)
                if x == -0x1.247ab0p-6
                    # XXX: Maybe bug:
                    #      Float32(-0x1.271f10p-6)
                    return Float32(-0x1.271f0ep-6) - Float32(0x1p-31)
                end
                if x == -0x1.3a415ep-5
                    return Float32(-0x1.407112p-5) + Float32(0x1p-30)
                end
                if x == 0x1.fb035ap-2
                    return Float32(+0x1.9bddc2p-2) + Float32(0x1p-27)
                end
                trf += 64*(rl + (Lh - trf))
            elseif (rl + (Lh - trf)) == 0
                if x == 0x1.b7fd86p-4
                    return Float32(+0x1.a1ece2p-4) + Float32(0x1p-29)
                end
                if x == -0x1.3a415ep-5
                    return Float32(-0x1.407112p-5) + Float32(0x1p-30)
                end
                if x == 0x1.43c7e2p-6
                    return Float32(+0x1.409f80p-6) + Float32(0x1p-31)
                end
            end
            ub = trf
        end

        return Float32(ub)
    end
end
