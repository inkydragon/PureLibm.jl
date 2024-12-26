# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary64/rsqrt/rsqrt.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

function as_rsqrt_refine(rf::Float64, a::Float64)::Float64
    iru = reinterpret(UInt64, rf)
    iau = reinterpret(UInt64, a)
    if iau < (UInt64(1) << 52)
        nz = _llvm_clz(iau)
        iau <<= nz - 11
        iau &= ~UInt64(0) >> 12
        e = nz - 12
        iau |= e << 52
    end

    if (iau << 11) == (UInt64(1) << 63)
        # Do nothing
    else
        mode = rounding(Float64)
        e = (iau >> 52) & 1
        rm = ((iru << 11 | (UInt64(1) << 63)) >> 11) % UInt64
        am = (((iau & (~UInt64(0) >> 12)) | (UInt64(1) << 52)) << (5 - e)) % UInt64
        rt = UInt128(rm) * UInt128(am)
        rth = (rt >> 64) % UInt64
        rtl = rt % UInt64
        rrt = UInt128(rtl) * UInt128(rm)
        t0 = rrt % UInt64
        t1 = ((rrt >> 64) + rth * rm) % UInt64
        rrt = UInt128(t1) << 64 | t0
        s = Int64(rrt >> 127)
        dd = Int64(1 - 2 * s)
        rts = ((rt << 1) ⊻ (-s)) + s
        prrt = UInt128(0)
        am2 = am << 1
        am20 = ~am
        while true
            iru -= (dd % UInt64) 
            prrt = rrt
            am20 += am2
            tt = UInt128(rts - am20)
            rrt -= tt
            if ((prrt ^ rrt) >> 127) == 0
                break
            end
        end
        iru += ifelse((rrt >> 127) == 1, UInt64(0), dd % UInt64)
        rrt = ifelse((rrt >> 127) == 1, rrt, prrt)
        if mode == RoundNearest  # FE_TONEAREST
            rm = ((iru << 11 | (UInt64(1) << 63)) >> 11) % UInt64
            rt = UInt128(rm) * UInt128(am)
            rrt += am >> 2
            rrt += rt
            inc = (rrt >> 127) % UInt64
            iru += inc
        else
            # FE_UPWARD
            iru += (mode == RoundUp) ? UInt64(1) : UInt64(0)
        end
        irf = reinterpret(Float64, iru)
        rf = irf
    end
    return rf
end

"""
Correctly-rounded reciprocal square root of Float64
"""
function cr_rsqrt(x::Float64)::Float64
    ixu = reinterpret(UInt64, x)

    r = 0.0
    if ixu < (UInt64(1) << 52)
        if ixu != 0
            r = sqrt(x) / x
        else
            return Inf64
        end
    elseif ixu >= (UInt64(0x7ff) << 52)
        if (ixu << 1) == 0
            return -Inf64  # x = -0
        end
        if ixu > 0xfff0_0000_0000_0000
            return x + x  # NaN
        end
        if (ixu >> 63) == 1
            # feraiseexcept(FE_INVALID)
            return -NaN64
        end
        if (ixu << 12) == 0
            return 0.0  # +Inf
        end
        return x + x  # NaN
    else
        r = (1.0 / x) * sqrt(x)
    end

    rx = r * x
    drx = fma(r, x, -rx)
    h = fma(r, rx, -1.0) + r * drx
    dr = (r * 0.5) * h
    rf = r - dr
    dr -= r - rf
    idru = reinterpret(UInt64, dr)
    iru = reinterpret(UInt64, rf)
    aidr = (idru & (~UInt64(0) >> 1)) 
            - (iru & (UInt64(0x7ff) << 52)) 
            + (UInt64(0x3fe) << 52)
    mid = (aidr - 0x3c90_0000_0000_0000 + 16) >> 5
    if mid == 0 || aidr < 0x39b0_0000_0000_0000 || aidr > 0x3c9f_ffff_ffff_ff80
        rf = as_rsqrt_refine(rf, x)
    end

    return rf
end
