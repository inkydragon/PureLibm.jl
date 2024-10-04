
function poly12(z::Float64, c::Vector{Float64})::Float64
    """Polynomial evaluation for 12 coefficients
    """
    @assert 12 == length(c)

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
