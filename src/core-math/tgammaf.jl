# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on core-math/src/binary32/tgamma/tgammaf.c
# CORE-MATH project Copyright (c) 2023-2024 Alexei Sibidanov.

"""
List of exceptional cases.
"""
const _CR_TGAMMAF_TB = Vector{Tuple{UInt32, Float32, Float32}}([
    (UInt32(0x27de86a9), Float32(0x1.268266p+47), Float32(0x1p22)),
    (UInt32(0x27e05475), Float32(0x1.242422p+47), Float32(0x1p22)),
    (UInt32(0xb63befb3), Float32(-0x1.5cb6e4p+18), Float32(0x1p-7)),
    (UInt32(0x3c7bb570), Float32(0x1.021d9p+6), Float32(0x1p-19)),
    (UInt32(0x41e886d1), Float32(0x1.33136ap+98), Float32(0x1p73)),
    (UInt32(0xc067d177), Float32(0x1.f6850cp-3), Float32(0x1p-28)),
    (reinterpret(UInt32, Float32(-0x1.33b462p-4)), Float32(-0x1.befe66p+3), Float32(-0x1p-22)),
    (reinterpret(UInt32, Float32(-0x1.a988b4p-1)), Float32(-0x1.a6b4ecp+2), Float32(0x1p-23)),
    (reinterpret(UInt32, Float32(0x1.dceffcp+4)), Float32(0x1.d3631cp+101), Float32(-0x1p-76)),
    (reinterpret(UInt32, Float32(0x1.0874c8p+0)), Float32(0x1.f6c638p-1), Float32(0x1p-26))
])

const _CR_TGAMMAF_C = Vector{Float64}([
    0x1.c9a76be577123p+0, 0x1.8f2754ddcf90dp+0, 0x1.0d1191949419bp+0, 0x1.e1f42cf0ae4a1p-2,
    0x1.82b358a3ab638p-3, 0x1.e1f2b30cd907bp-5, 0x1.240f6d4071bd8p-6, 0x1.1522c9f3cd012p-8,
    0x1.1fd0051a0525bp-10, 0x1.9808a8b96c37ep-13, 0x1.b3f78e01152b5p-15, 0x1.49c85a7e1fd04p-18,
    0x1.471ca49184475p-19, -0x1.368f0b7ed9e36p-23, 0x1.882222f9049efp-23, -0x1.a69ed2042842cp-25
])


function cr_tgammaf(x::Float32)::Float32
    tb = _CR_TGAMMAF_TB

    tu = reinterpret(UInt32, x)
    ax = tu << 1
    if @unlikely(ax >= (UInt32(0xff) << 24))
        #= x=NaN or +/-Inf =#
        if ax == (UInt32(0xff) << 24)
            # x=+/-Inf
            if (tu >> 31) != 0
                # x=-Inf
                # TODO? errno = EDOM
                # will raise the "Invalid operation" exception
                return x / x
            end
            # x=+Inf
            return x
        end
        # x=NaN,
        #   where x+x ensures the "Invalid operation" exception is set if x is sNaN
        return x + x 
    end

    z = Float64(x)
    if @unlikely(ax < 0x6d00_0000)
        #= |x| < 0x1p-18 =#
        d = (0x1.fa658c23b1578p-1 - 0x1.d0a118f324b63p-1 * z) * z - 0x1.2788cfc6fb619p-1
        f = 1.0 / z + d
        r = Float32(f)
        if abs(r) > Float32(0x1.fffffep+127)
            # TODO? errno = ERANGE
        end
        rtu = reinterpret(UInt64, f)
        if @unlikely(((rtu + 2) & 0x0fff_ffff) < 4)
            for i in 1:length(tb)
                if tu == tb[i][1]
                    return tb[i][2] + tb[i][3]
                end
            end
        end

        return r
    end

    fx = floor(x)
    if @unlikely(x >= Float32(0x1.18522p+5))
        # The C standard says that if the function overflows, errno is set to ERANGE.
        # TODO? errno = ERANGE
        return Float32(0x1p127) * Float32(0x1p127)
    end

    # compute k only after the overflow check,
    #   otherwise the case to integer might overflow
    k = trunc(Int, fx)
    if @unlikely(fx == x)
        #= x is integer =#
        if x == 0.0
            # TODO? errno = ERANGE
            return Float32(1.0) / x
        end
        if x < 0.0
            # TODO? errno = EDOM
            # should raise the "Invalid operation" exception
            return Float32(0.0) / Float32(0.0)
        end

        t0 = Float64(1.0)
        x0 = Float64(1.0)
        for _ in 1:(k-1)
            t0 *= x0
            x0 += 1.0
        end
        return Float32(t0)
    end

    if @unlikely(x < -42.0)
        #= negative non-integer =#
        # For x < -42, x non-integer, |gamma(x)| < 2^-151.
        sgn = (Float32(0x1p-127), -Float32(0x1p-127))
        # The C standard says that if the function underflows, errno is set to ERANGE.
        # TODO? errno = ERANGE
        return Float32(0x1p-127) * sgn[k & 1 + 1]
    end

    m = z - 0x1.7p+1
    i = _llvm_roundeven(m)
    step = copysign(1.0, i)

    d = m - i
    d2 = d * d
    d4 = d2 * d2
    d8 = d4 * d4
    c = _CR_TGAMMAF_C

    f = (
        (c[1] + d * c[2])
        + d2 * (c[3] + d * c[4])
        + d4 * ((c[5] + d * c[6]) + d2 * (c[7] + d * c[8]))
        + d8 * (
            (c[9] + d * c[10]) 
            + d2 * (c[11] + d * c[12]) 
            + d4 * ((c[13] + d * c[14]) + d2 * (c[15] + d * c[16])))
    )

    jm = trunc(Int, abs(i))
    w = Float64(1.0)
    if jm != 0
        z -= 0.5 + step * 0.5
        w = z
        for _ in 1:(jm-1)
            z -= step
            w *= z
        end
    end
    if i <= -0.5
        w = 1.0 / w
    end
    f *= w

    rtu = reinterpret(UInt64, f)
    r = Float32(f)
    if @unlikely(r == 0.0)
        # TODO? errno = ERANGE
    end

    #= Deal with exceptional cases =#
    if @unlikely(((rtu + 2) & 0xfffffff) < 8)
        for j in 1:length(tb)
            if tu == tb[j][1]
                return tb[j][2] + tb[j][3]
            end
        end
    end

    return r
end

tgamma(x::Float32) = cr_tgammaf(x)
