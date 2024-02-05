# SPDX-License-Identifier: MIT OR Apache-2.0
# Based on https://gitlab.inria.fr/core-math/core-math/-/blob/master/src/binary32/tgamma/tgammaf.c

const GAMMA_C = Float64[
    0x1.c9a76be577123p+0, 0x1.8f2754ddcf90dp+0, 
    0x1.0d1191949419bp+0, 0x1.e1f42cf0ae4a1p-2,
    0x1.82b358a3ab638p-3, 0x1.e1f2b30cd907bp-5, 
    0x1.240f6d4071bd8p-6, 0x1.1522c9f3cd012p-8,
    0x1.1fd0051a0525bp-10, 0x1.9808a8b96c37ep-13, 
    0x1.b3f78e01152b5p-15, 0x1.49c85a7e1fd04p-18,
    0x1.471ca49184475p-19, -0x1.368f0b7ed9e36p-23, 
    0x1.882222f9049efp-23, -0x1.a69ed2042842cp-25,
]

# Copy from: https://github.com/JuliaMath/SpecialFunctions.jl/blob/903344684698a435383977afd43e3d6f82b52608/src/gamma.jl#L578-L584
function _gamma(n::Union{Int32,Int64})
    n < 0 && throw(DomainError(n, "`n` must not be negative."))
    n == 0 && return Float32(Inf)
    n <= 2 && return Float32(1.0)
    # TODO: May overflow
    if n > 20
        r0 = Float32(Base._fact_table64[20-1])
        for i in 21:n
            r0 *= i
        end 
        return r0
    end
    @inbounds return Float32(Base._fact_table64[n-1])
end

macro gamma_hard_to_round(expr)
    quote
        # TODO:
    end
end

"""
    tgammaf(x::Float32)
    
Compute the Gamma function for input `x`.
"""
function tgammaf(x::Float32)
    z = Float64(x)
    ux = reinterpret(UInt32, x)
    ax = reinterpret(UInt32, abs(x))

    # Check ±Inf, NaN input.
    if @unlikely(ax >= F32_POS_INF)
        if -Inf === x
            domain_error_ignore()
            return NaN
        end
        
        # +Inf, NaN
        return x
    end
    
    @assert 0 <= abs(x) && abs(x) < Inf
    # abs(x) < 0x1p-18 (3.8146​×10-6)
    if @unlikely(ax < 0x6d000000)
        d = (0x1.fa658c23b1578p-1 - 0x1.d0a118f324b63p-1*z)*z - 0x1.2788cfc6fb619p-1
        f = 1.0/z + d
        r = Float32(f)
        
        ax > F32_MAX_FINITE && overflow_error()
        @gamma_hard_to_round(x)
        
        return r
    end
    
    # Overflow: x >= 35.0401
    if @unlikely(x >= Float32(0x1.18522p+5))
        # [Rounding checks] Overflow test
        r = Float32(0x1p+127) * Float32(0x1p+127)
        ax > F32_MAX_FINITE && overflow_error()
        return r
    end
    
    fx = floor(Float32, x)
    k = floor(Int32, x)
    if @unlikely(fx == x)
        # x is Integer
        if x == 0.0f0
            pole_error(x)
            return 1.0 / x
        end
        if x < 0.0f0
            domain_error_ignore()
            return NaN
        end
        return Float32(_gamma(k))
    end
    
    if @unlikely(x < -47.0f0)
        # [Rounding checks] Underflow test
        r = Float32(0x1p-127) * Float32(0x1p-127)
        # Odd => -0.0  Even => +0.0
        r = copysign(r, isodd(k) ? -0.0 : 0.0)
        r == 0.0f0 && underflow_error()
        return r
    end
    
    # ---- polynomial approximation
    m = z - 0x1.7p+1
    i = round(Float64, m)
    step = copysign(1.0, i)
    
    d = m - i
    d2 = d * d
    d4 = d2 * d2
    d8 = d4 * d4
    
    # TODO: use evalpoly
    f = (GAMMA_C[0] + d*GAMMA_C[1]) 
        + d2*(GAMMA_C[2] + d*GAMMA_C[3]) 
        + d4*((GAMMA_C[4] + d*GAMMA_C[5]) + d2*(GAMMA_C[6] + d*GAMMA_C[7]))
        + d8*(
            (GAMMA_C[8] + d*GAMMA_C[9]) 
            + d2*(GAMMA_C[10] + d*GAMMA_C[11]) 
            + d4*((GAMMA_C[12] + d*GAMMA_C[13]) + d2*(GAMMA_C[14] + d*GAMMA_C[15]))
        )
    
    w = 1.0
    jm = trunc(Int, abs(i))
    if jm > 0
        z -= 0.5 + step*0.5
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
    r = Float32(f)
    if @unlikely(r == 0.0f0)
        pole_error(x)
    end
    
    @gamma_hard_to_round(f)

    return r
end
