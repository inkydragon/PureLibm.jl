# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on openlibm/src/e_sqrtf.c
"""
Conversion to float by Ian Lance Taylor, Cygnus Support, ian@cygnus.com.

====================================================
Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.

Developed at SunSoft, a Sun Microsystems, Inc. business.
Permission to use, copy, modify, and distribute this
software is freely granted, provided that this notice
is preserved.
====================================================
"""

function __ieee754_sqrtf(x::Float32)::Float32
    # Const
    ONE = Float32(1.0)
    TINY = Float32(1.0e-30)
    sign = UInt32(0x80000000)
    # Var
    z = Float32(0.0)
    ix = reinterpret(Int32, x)

    # take care of Inf and NaN
    if (ix & 0x7f800000) == 0x7f800000
        # sqrt(NaN)=NaN, sqrt(+inf)=+inf, sqrt(-inf)=NaN
        return x * x + x
    end

    # take care of zero
    if ix <= 0
        if (ix & ~sign) == 0
            # sqrt(+-0) = +-0
            return x
        end
        if ix < 0
            # sqrt(-ve) = sNaN
            return (x - x) / (x - x)
        end
    end

    # normalize x
    m = Int32(ix >> 23)
    if m == 0
        # subnormal x
        i = 0
        while (ix & 0x00800000) == 0
            ix <<= 1
            i += 1
        end
        m -= i - 1
    end
    m -= 127  # unbias exponent
    ix = (ix & 0x007fffff) | 0x00800000

    if (m & 1) == 1
        # odd m, double x to make it even
        ix += ix
    end
    m >>= 1  # m = [m / 2]

    # generate sqrt(x) bit by bit
    ix += ix
    # q = sqrt(x)
    q = Int32(0)
    s = Int32(0)
    # r = moving bit from right to left
    r = UInt32(0x01000000)

    while r != 0
        t = s + Int32(r)
        if t <= ix
            s = t + Int32(r)
            ix -= t
            q += Int32(r)
        end
        ix += ix
        r >>= 1
    end

    # use floating add to find out rounding direction
    if ix != 0
        # trigger inexact flag
        z = ONE - TINY
        if z >= ONE
            z = ONE + TINY
            if z > ONE
                q += 2
            else
                q += q & 1
            end
        end
    end

    ix = (q >> 1) + 0x3f000000
    ix += m << 23
    return reinterpret(Float32, Int32(ix))
end

sqrt(x::Float32) = __ieee754_sqrtf(x)
