
"""
Polynomial evaluation for 12 coefficients
"""
function poly12(z::T, c::NTuple{12, T}) where T
    z2 = z * z
    z4 = z2 * z2
    c0 = c[1] + z * c[2]
    c2 = c[3] + z * c[4]
    c4 = c[5] + z * c[6]
    c6 = c[7] + z * c[8]
    c8 = c[9] + z * c[10]
    c10 = c[11] + z * c[12]
    c0 += c2 * z2
    c4 += c6 * z2
    c8 += z2 * c10
    c0 += z4 * (c4 + z4 * c8)

    return c0
end

"""
Multiplies two double-double precision numbers represented
by their high and low parts, `(xh, xl) * (ch, cl)`.

# Arguments
- `(xh, xl)`:   `(high, low)` parts of `x` in double-double precision
- `(ch, cl)`:   `(high, low)` parts of `c` in double-double precision

# Returns
- The `(high, low)` parts of the product.
"""
# function muldd(xh::Float64, xl::Float64, ch::Float64, cl::Float64)
#     ahlh = ch * xl
#     alhh = cl * xh
#     ahhh = ch * xh
#     ahhl = fma(ch, xh, -ahhh)
#     ahhl += alhh + ahlh
#     ch = ahhh + ahhl
#     cl = (ahhh - ch) + ahhl
#     return ch, cl
# end

"""
Evaluate a polynomial using double-double arithmetic,
`eval_poly_n((xh, xl), c...)`.

# Arguments
- `(xh, xl)`:   `(high, low)` parts of `x` in double-double precision
- `n`:  The degree of the polynomial.
- `c`:  The coefficients of the polynomial,
        where each coefficient is a tuple of its `(high, low)` parts.

# Returns
- The `(high, low)` parts of the evaluated polynomial.
"""
# function polydd(xh::Float64, xl::Float64, n::Int, c::Vector{Tuple{Float64, Float64}})
#     @assert n == length(c)
#     i = n
#     ch = c[i][1]
#     cl = c[i][2]
#     while i >= 1
#         ch, cl = muldd(xh, xl, ch, cl)
#         th = ch + c[i - 1][1]
#         tl = (c[i - 1][1] - th) + ch
#         ch = th
#         cl += tl + c[i - 1][2]
#         i -= 1
#     end
#     return ch, cl
# end
