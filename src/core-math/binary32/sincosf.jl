# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/sincos/sincosf.c
# CORE-MATH project Copyright (c) 2024-2025 Alexei Sibidanov

const CR_SINCOSF_ST = Vector{Tuple{UInt32, Float32, Float32, Float32, Float32}}([
    (reinterpret(UInt32, Float32(0x1.33333p+13)), Float32(-0x1.63f4bap-2), Float32(-0x1p-27), Float32(-0x1.e01216p-1), Float32(-0x1p-26)),
    (reinterpret(UInt32, Float32(0x1.75b8a2p-1)), Float32(0x1.55688ap-1), Float32(-0x1p-26), Float32(0x1.7d8e1ep-1), Float32(0x1p-26)),
    (reinterpret(UInt32, Float32(0x1.4f0654p+0)), Float32(0x1.ee836cp-1), Float32(-0x1p-26), Float32(0x1.09558p-2), Float32(-0x1p-27)),
    (reinterpret(UInt32, Float32(0x1.2d97c8p+3)), Float32(-0x1.99bc5ap-26), Float32(-0x1p-51), Float32(-0x1p+0), Float32(0x1p-25)),
    (reinterpret(UInt32, Float32(0x1.2d97c8p+2)), Float32(-0x1p+0), Float32(0x1p-25), Float32(0x1.99bc5cp-27), Float32(-0x1p-52)),
    (reinterpret(UInt32, Float32(0x1.4555p+51)), Float32(-0x1.b0ea44p-1), Float32(0x1p-26), Float32(0x1.115d7ep-1), Float32(-0x1p-26)),
    (reinterpret(UInt32, Float32(0x1.48a858p+54)), Float32(0x1.beac8cp-1), Float32(0x1p-26), Float32(0x1.f48148p-2), Float32(0x1p-27)),
    (reinterpret(UInt32, Float32(0x1.3170fp+63)), Float32(0x1.5ac1eep-4), Float32(-0x1p-30), Float32(0x1.fe2976p-1), Float32(0x1p-26)),
    (reinterpret(UInt32, Float32(0x1.2b9622p+67)), Float32(-0x1.f983c2p-3), Float32(0x1p-28), Float32(0x1.f0285ep-1), Float32(-0x1p-26)),
])


function _sincosf_database(x::Float32, s0::Float32, c0::Float32)
    tu = reinterpret(UInt32, x)
    ax = tu & (~UInt32(0) >> 1)
    for (uarg, sh, sl, ch, cl) in CR_SINCOSF_ST
        if ax == uarg
            sout = add_sign(x, sh, sl)
            cout = ch + cl
            return sout, cout
        end
    end

    return s0, c0
end

function _sincosf_big(x::Float32)
    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax >= (UInt32(0xff) << 24))  # nan or +-inf
        if (ax << 8) != 0
            sout = x + x
            cout = x + x
            return sout, cout  # NaN
        end
        # to raise FE_INVALID
        sout = 0.0f0 / 0.0f0
        cout = 0.0f0 / 0.0f0
        return sout, cout
    end

    z, ia = _sinf_rbig(tu)
    aa, bb, s0, c0 = _sinf_absc(z, ia)
    bb = bb * z
    s = s0 + z * (aa * c0 - bb * s0)
    c = c0 - z * (aa * s0 + bb * c0)
    sout = Float32(s)
    cout = Float32(c)

    tru = reinterpret(UInt64, c)
    tail = (tru + UInt64(6)) & (~UInt64(0) >> 36);
    if tail <= 12
        return _sincosf_database(x, sout, cout)
    end

    return sout, cout
end

"""
Correctly-rounded sine and cosine of `Float32`.
"""
function cr_sincosf(x::Float32)::Tuple{Float32, Float32}
    tu = reinterpret(UInt32, x)
    ax = tu << 1

    ia = 0
    z0 = Float64(x)
    z = 0.0
    sout, cout = Float32(0.0), Float32(0.0)
    # |x| < 0x1.2d97c8p+3
    if ax < 0x822d97c8
        # |x| < 0x1p-12
        if ax < 0x73000000
            # |x| < 0x1p-25
            if ax < 0x66000000
                if ax == 0
                    sout = x
                    cout = Float32(1.0)
                else
                    sout = -x * abs(x) + x
                    cout = Float32(1.0) - Float32(0x1p-25)
                end
            else
                sout = (-Float32(0x1.555556p-3) * x) * (x * x) + x
                cout = (-Float32(0x1p-1) * x) * x + Float32(1.0)
            end
            return sout, cout
        end

        if ax == 0x812d97c8
            # tu == 0x4096cbe4 (4.712389f0)
            return _sincosf_database(x, sout, cout)
        end
        z, ia = rltl0(z0)
    else
        if ax > 0x99000000
            return _sincosf_big(x)
        end
        if ax == 0x8c333330
            # tu == 0x46199998 (9830.398f0)
            return _sincosf_database(x, sout, cout)
        end
        z, ia = rltl(z0)
    end

    aa, bb, s0, c0 = _sinf_absc(z, ia)
    z2 = z * z
    aa = aa * z
    bb = bb * z2
    s = s0 + (aa * c0 - bb * s0)
    c = c0 - (aa * s0 + bb * c0)
    sout = Float32(s)
    cout = Float32(c)
    return sout, cout
end
