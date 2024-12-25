# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on musl/src/math/cbrtf.c
"""
====================================================
Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.

Developed at SunSoft, a Sun Microsystems, Inc. business.
Permission to use, copy, modify, and distribute this
software is freely granted, provided that this notice
is preserved.
====================================================

Conversion to float by Ian Lance Taylor, Cygnus Support, ian@cygnus.com.
Debugged and optimized by Bruce D. Evans.
"""

function cbrtf(x::Float32)::Float32
    # Const
    B1 = UInt32(709958130)  # B1 = (127-127.0/3-0.03306235651)*2^23
    B2 = UInt32(642849266)  # B2 = (127-127.0/3-24/3-0.03306235651)*2^23

    # Var
    r = Float64(0.0)
    t = Float32(0.0)
    tt = Float64(0.0)
    ui = reinterpret(UInt32, x)
    hx = ui & 0x7fffffff

    if hx >= 0x7f800000
        # cbrt(NaN, INF) is itself
        return x + x
    end

    # Rough cbrt to 5 bits
    if hx < 0x00800000
        # zero or subnormal?
        if hx == 0
            # cbrt(+-0) is itself
            return x
        end

        x1p24 = Float32(0x1p24)  # 0x1p24f === 2^24
        ui = reinterpret(UInt32, x * x1p24)
        hx = ui & 0x7fffffff
        hx = div(hx, UInt32(3)) + B2
    else
        hx = div(hx, UInt32(3)) + B1
    end
    ui &= 0x80000000
    ui |= hx

    # First step Newton iteration (solving t*t - x/t == 0) to 16 bits
    # In double precision so that its terms can be arranged for efficiency
    # without causing overflow or underflow.
    tt = reinterpret(Float32, ui)
    r = tt * tt * tt
    tt = tt * (Float64(x) + x + r) / (x + r + r)

    # Second step Newton iteration to 47 bits. In double precision for
    # efficiency and accuracy.
    r = tt * tt * tt
    tt = tt * (Float64(x) + x + r) / (x + r + r)

    # Rounding to 24 bits is perfect in round-to-nearest mode
    return Float32(tt)
end

musl_cbrt(x::Float32) = cbrtf(x)
