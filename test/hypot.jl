# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_hypot($T)" begin
        # IEC 60559
        # hypot(x, y), hypot(y, x), and hypot(x, −y) are equivalent.
        # hypot(x, ±0) returns the absolute value of x, if x is not a NaN.
        # hypot(±∞, y) returns +∞, even if y is a NaN.
        # hypot(x, NaN) returns a NaN, if x is not ±∞.

        # sanity check
    end
end
