# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/rsqrt/rsqrtf.c
# CORE-MATH project Copyright (c) 2022-2023 Alexei Sibidanov.

"""
Correctly-rounded reciprocal square root of Float32
"""
function cr_rsqrtf(x::Float32)::Float32
    xd = Float64(x)
    ixu = reinterpret(UInt32, x)

    if ixu >= (UInt32(0xff) << 23) || ixu == 0
        if (ixu << 1) == 0
            return Float32(1.0) / x
        end
        if (ixu >> 31) != 0
            ixu &= ~UInt32(0) >> 1
            if ixu > (UInt32(0xff) << 23)
                return x
            end

            # feraiseexcept(FE_INVALID)
            return NaN32
        end
        if (ixu << 9) == 0
            return Float32(0.0)
        end
        return x
    end

    m = UInt32(ixu << 8)
    if ixu == 0x002f_7e2a || m == 0xbdf8_a800 || m == 0x55b7_bd00
        if ixu != 0x0055_b7bd
            e = ixu >> 23
            k = 1
            if ixu == 0x002f_7e2a
                e = -1
            end
            if m == 0x55b7_bd00
                k = 0
            end
            tb = (0x000c_1740, 0x0052_22e0)
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


rsqrt(x::Float32) = cr_rsqrtf(x)
