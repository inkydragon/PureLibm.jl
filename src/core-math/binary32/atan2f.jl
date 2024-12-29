# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/acos/acosf.c
# CORE-MATH project Copyright (c) 2022 Alexei Sibidanov.

const CR_ATAN2F_CN = [0x1p+0, 0x1.40e0698f94c35p+1, 0x1.248c5da347f0dp+1, 0x1.d873386572976p-1, 0x1.46fa40b20f1dp-3, 0x1.33f5e041eed0fp-7, 0x1.546bbf28667c5p-14]
const CR_ATAN2F_CD = [0x1p+0, 0x1.6b8b143a3f6dap+1, 0x1.8421201d18ed5p+1, 0x1.8221d086914ebp+0, 0x1.670657e3a07bap-2, 0x1.0f4951fd1e72dp-5, 0x1.b3874b8798286p-11]
const CR_ATAN2F_C = Vector{Tuple{Float64, Float64}}([
    (0x1p+0, -0x1.8c1dac5492248p-87), (-0x1.5555555555555p-2, -0x1.55553bf3a2abep-56),
    (0x1.999999999999ap-3, -0x1.99deed1ec9071p-57), (-0x1.2492492492492p-3, -0x1.fd99c8d18269ap-58),
    (0x1.c71c71c71c717p-4, -0x1.651eee4c4d9dp-61), (-0x1.745d1745d1649p-4, -0x1.632683d6c44a6p-58),
    (0x1.3b13b13b11c63p-4, 0x1.bf69c1f8af41dp-58), (-0x1.11111110e6338p-4, 0x1.3c3e431e8bb68p-61),
    (0x1.e1e1e1dc45c4ap-5, -0x1.be2db05c77bbfp-59), (-0x1.af286b8164b4fp-5, 0x1.a4673491f0942p-61),
    (0x1.86185e9ad4846p-5, 0x1.e12e32d79fceep-59), (-0x1.642c6d5161faep-5, 0x1.3ce76c1ca03fp-59),
    (0x1.47ad6f277e5bfp-5, -0x1.abd8d85bdb714p-60), (-0x1.2f64a2ee8896dp-5, 0x1.ef87d4b615323p-61),
    (0x1.1a6a2b31741b5p-5, 0x1.a5d9d973547eep-62), (-0x1.07fbdad65e0a6p-5, -0x1.65ac07f5d35f4p-61),
    (0x1.ee9932a9a5f8bp-6, 0x1.f8b9623f6f55ap-61), (-0x1.ce8b5b9584dc6p-6, 0x1.fe5af96e8ea2dp-61),
    (0x1.ac9cb288087b7p-6, -0x1.450cdfceaf5cap-60), (-0x1.84b025351f3e6p-6, 0x1.579561b0d73dap-61),
    (0x1.52f5b8ecdd52bp-6, 0x1.036bd2c6fba47p-60), (-0x1.163a8c44909dcp-6, 0x1.18f735ffb9f16p-60),
    (0x1.a400dce3eea6fp-7, -0x1.c90569c0c1b5cp-61), (-0x1.1caa78ae6db3ap-7, -0x1.4c60f8161ea09p-61),
    (0x1.52672453c0731p-8, 0x1.834efb598c338p-62), (-0x1.5850c5be137cfp-9, -0x1.445fc150ca7f5p-63),
    (0x1.23eb98d22e1cap-10, -0x1.388fbaf1d783p-64), (-0x1.8f4e974a40741p-12, 0x1.271198a97da34p-66),
    (0x1.a5cf2e9cf76e5p-14, -0x1.887eb4a63b665p-68), (-0x1.420c270719e32p-16, 0x1.efd595b27888bp-71),
    (0x1.3ba2d69b51677p-19, -0x1.4fb06829cdfc7p-73), (-0x1.29b7e6f676385p-23, -0x1.a783b6de718fbp-77)
])


"""
For `y/x` tiny, use Taylor approximation `z - z^3/3` where `z=y/x`
"""
function cr_atan2f_tiny(y::Float32, x::Float32)
    dy = Float64(y)
    dx = Float64(x)
    z = dy / dx
    e = fma(-z, x, y)
    # z * x + e = y thus y/x = z + e/x
    c = -0x1.5555555555555p-2  # -1/3 rounded to nearest
    zz = z * z
    cz = c * z
    e = e / x + cz * zz
    t = reinterpret(UInt64, z)
    if (t & 0x0fff_ffff) == 0  # boundary case
        #= If z and e are of same sign (resp. of different signs), we increase
            (resp. decrease) the significant of t by 1 to avoid a double-rounding
            issue when rounding t.f to binary32.
        =#
        if z * e > 0
            t += 1
        else
            t -= 1
        end
    end
    return reinterpret(Float64, t)
end

function cr_atan2f(y::Float32, x::Float32)::Float32
    pi1 = 0x1.921fb54442d18p+1
    @assert Float64(pi) == pi1
    pi2 = 0x1.921fb54442d18p+0
    pi2l = 0x1.1a62633145c07p-54
    off = (0.0, pi2, pi, pi2, -0.0, -pi2, -pi, -pi2)
    offl = (0.0, pi2l, 2*pi2l, pi2l, -0.0, -pi2l, -2*pi2l, -pi2l)
    sgn = (1, -1)

    tx = reinterpret(UInt32, x)
    ty = reinterpret(UInt32, y)
    ux = tx
    uy = ty
    ax = ux & (~UInt32(0) >> 1)
    ay = uy & (~UInt32(0) >> 1)

    if ay >= (UInt32(0xff) << 23) || ax >= (UInt32(0xff) << 23)
        if ay > (UInt32(0xff) << 23)
            return y
        end
        if ax > (UInt32(0xff) << 23)
            return x
        end
        yinf = ay == (UInt32(0xff) << 23)
        xinf = ax == (UInt32(0xff) << 23)
        if (yinf & xinf) != 0
            if (ux >> 31) != 0
                return 0x1.2d97c7f3321d2p+1 * sgn[(uy >> 31) + 1]
            else
                return 0x1.921fb54442d18p-1 * sgn[(uy >> 31) + 1]
            end
        end
        if xinf != 0
            if ux >> 31 != 0
                return pi * sgn[(uy >> 31) + 1]
            else
                return 0.0 * sgn[(uy >> 31) + 1]
            end
        end
        if yinf != 0
            return pi2 * sgn[(uy >> 31) + 1]
        end
    end

    if ay == 0
        if (ay | ax) == 0
            i = (uy >> 31) * 4 + (ux >> 31) * 2
            if ux >> 31 != 0
                return off[i + 1] + offl[i + 1]
            else
                return off[i + 1]
            end
        end
        if (ux >> 31) == 0
            return Float32(0.0) * sgn[(uy >> 31) + 1]
        end
    end

    gt = ay > ax
    i = (uy >> 31) * 4 + (ux >> 31) * 2 + gt
    zx = Float64(x)
    zy = Float64(y)
    m = (0, 1)
    z = (m[gt + 1] * zx + m[1 - gt + 1] * zy) / (m[gt + 1] * zy + m[1 - gt + 1] * zx)
    z2 = z * z
    z4 = z2 * z2
    z8 = z4 * z4

    cn = CR_ATAN2F_CN
    cn0 = cn[1] + z2 * cn[2]
    cn2 = cn[3] + z2 * cn[4]
    cn4 = cn[5] + z2 * cn[6]
    cn6 = cn[7]
    cn0 += z4 * cn2
    cn4 += z4 * cn6
    cn0 += z8 * cn4
    z *= sgn[gt + 1]

    cd = CR_ATAN2F_CD
    cd0 = cd[1] + z2 * cd[2]
    cd2 = cd[3] + z2 * cd[4]
    cd4 = cd[5] + z2 * cd[6]
    cd6 = cd[7]
    cd0 += z4 * cd2
    cd4 += z4 * cd6
    cd0 += z8 * cd4

    r = cn0 / cd0
    r = z * r + off[i + 1]
    res_u = reinterpret(UInt64, r)

    if ((res_u + UInt64(8)) & 0x0fff_ffff) <= 16
        if ay < ax && ((ax - ay) >> 23) >= 25
            return cr_atan2f_tiny(y, x)
        end

        zh, zl = if !gt
            zy / zx, fma(zy / zx, -zx, zy) / zx
        else
            zx / zy, fma(zx / zy, -zy, zx) / zy
        end

        z2h, z2l = muldd(zh, zl, zh, zl)
        ph, pl = polydd(z2h, z2l, 32, CR_ATAN2F_C)
        zh *= sgn[gt + 1]
        zl *= sgn[gt + 1]
        ph, pl = muldd(zh, zl, ph, pl)

        sh = ph + off[i + 1]
        sl = ((off[i + 1] - sh) + ph) + pl + offl[i + 1]
        rf = sh
        th = rf
        dh = sh - th
        tm = dh + sl
        tth_u = reinterpret(UInt64, th)
        if (th + th * 0x1p-60) == (th - th * 0x1p-60)
            tth_u &= UInt64(0x7ff) << 52
            tth_u -= UInt64(24) << 52
            if abs(tm) > reinterpret(Float64, tth_u)
                tm *= 1.25
            else
                tm *= 0.75
            end
        end
        r = th + tm
    end

    return r
end
