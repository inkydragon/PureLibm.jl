# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/cbrt/cbrtf.c
# CORE-MATH project Copyright (c) 2023 Alexei Sibidanov.

const CR_CBRTF_ESCALE = NTuple{3,Float64}((
    1.0,
    0x1.428a2f98d728bp+0,   # 2^(1/3)
    0x1.965fea53d6e3dp+0,   # 2^(2/3)
))

const CR_CBRTF_C = NTuple{8,Float64}((
    0x1.2319d352ea5d5p-1,
    0x1.67ad8ee258d1ap-1,
    -0x1.9342edf9cbad9p-2,
    0x1.b6388fc510a75p-3,
    -0x1.6002455599e2fp-4,
    0x1.7b096936192c4p-6,
    -0x1.e5577187e8bf8p-9,
    0x1.169ef81d6c34ep-12,
))

"""
    cr_cbrt(x::Float32)

Correctly-rounded cubic root of `Float32` value.

# Examples
```jldoctest
julia> PureLibm.cr_cbrt.(Float32[-0.0, 0.0, 1e-3, 1e-9, 1e-30])
5-element Vector{Float32}:
 -0.0
  0.0
  0.1
  0.001
  1.0f-10

julia> PureLibm.cr_cbrt(Float32(-pi)) === -PureLibm.cr_cbrt(Float32(pi))
true

julia> PureLibm.cr_cbrt(Inf32)
Inf32
```

# Reference

"""
cr_cbrt(x::Float32) = cr_cbrtf(x)

function cr_cbrtf(x::Float32)
    # flag = get_rounding_mode()
    tu = reinterpret(UInt32, x)
    au = UInt32(tu << 1)
    sgn = UInt32(tu >> 31)
    e = UInt32(au >> 24)
    if (au < (UInt32(1) << 24) || au >= (UInt32(0xff) << 24))
        if au >= (UInt32(0xff) << 24)
            return x + x  # inf or nan
        end
        if au == 0
            return x  # ±0
        end

        nz = Int(_llvm_clz(au) - 7)  # subnormal
        au <<= nz
        e -= nz - 1
    end

    mant = au & 0xffffff
    cvt1u = (UInt64(mant) << 28) | (UInt64(0x3ff) << 52)
    cvt1f = reinterpret(Float64, cvt1u)

    e += 899
    et = UInt32(e ÷ 3)
    it = UInt32(e % 3)
    isc = reinterpret(UInt64, CR_CBRTF_ESCALE[it+1])
    isc += reinterpret(UInt64, et - 342) << 52
    isc |= UInt64(sgn) << 63
    cvt2u = isc
    cvt2 = reinterpret(Float64, cvt2u)

    z = cvt1f
    r0 = -0x1.9931c6c2d19d1p-6 / z
    z2 = z * z
    z4 = z2 * z2
    c = CR_CBRTF_C
    f = (
        ((c[1] + z * c[2]) + z2 * (c[3] + z * c[4])) +
        z4 * ((c[5] + z * c[6]) + z2 * (c[7] + z * c[8])) +
        r0
    )
    r = f * cvt2
    ub = Float32(r)
    lb = Float32(r - cvt2 * 1.4182e-9)
    if (ub == lb)
        # cvt2 = r
        # cvt2u = reinterpret(UInt64, cvt2)
        # if ((cvt2u&(UInt64(0x1fffff)<<24)) == 0)
        #     set_flags(flag)
        # end
        return ub
    end

    u0 = -0x1.ab16ec65d138fp+3
    h = f * f * f - z
    f -= (f * r0 * u0) * h
    r = f * cvt2

    cvt1f = r
    cvt1u = reinterpret(UInt64, cvt1f)
    ub = Float32(r)
    m0 = reinterpret(Int64, cvt1u << 19)
    m1 = m0 >> 63
    if ((m0 ⊻ m1) < (Int64(1) << 31))
        cvt1u = (cvt1u + (UInt64(1) << 31)) & 0xffffffff00000000
        ub = Float32(reinterpret(Float64, cvt1u))
        # set_flags(flag)
    end

    return ub
end
