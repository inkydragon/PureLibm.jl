
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
