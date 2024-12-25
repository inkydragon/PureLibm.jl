# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/rsqrt/rsqrtf.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

"""
Correctly-rounded reciprocal square root of Float32
"""
function cr_rsqrtf(x::Float32)::Float32
    xd = Float64(x)
    ixu = reinterpret(UInt32, x)

    if @unlikely(ixu >= (UInt32(0xff) << 23) || ixu == 0)
        if (ixu << 1) == 0
            # +-0
            return Float32(1.0) / x
        end
        if (ixu >> 31) != 0
            ixu &= ~UInt32(0) >> 1
            if ixu > (UInt32(0xff) << 23)
                # NaN
                return x + x
            end

            # feraiseexcept(FE_INVALID)
            return -NaN32
        end
        if (ixu << 9) == 0
            return Float32(0.0)
        end
        # NaN
        return x + x
    end

    m = UInt32(ixu << 8)
    # (x = 4.361527f-39, ixu = 0x002f7e2a, m = 0x2f7e2a00)
    # (x = 1.744611f-38, ixu = 0x00bdf8a8, m = 0xbdf8a800)
    # (x =-1.744611f-38, ixu = 0x80bdf8a8, m = 0xbdf8a800)
    # (x = 7.87193f-39,  ixu = 0x0055b7bd, m = 0x55b7bd00)
    # (x =-7.87193f-39,  ixu = 0x8055b7bd, m = 0x55b7bd00)
    if @unlikely(ixu == 0x002f7e2a || m == 0xbdf8a800 || m == 0x55b7bd00)
        if ixu != 0x0055b7bd
            # x != 7.87193f-39
            e = ixu >> 23
            k = 1
            if ixu == 0x002f7e2a
                e = -1
            end
            if m == 0x55b7bd00
                k = 0
            end
            tb = (0x000c1740, 0x005222e0)
            ru = tb[k + 1]
            e = UInt32((512 - e) / 2 - 578)
            ru |= e << 23
            rf = reinterpret(Float32, ru)
            dru = (e - 25) << 23
            drf = reinterpret(Float32, dru)
            return rf - drf
        end
    end

    # use __builtin_sqrt
    return (1.0 / xd) * sqrt(xd)
end
