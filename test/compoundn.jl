# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_compoundn($T)" begin
        # IEC 60559
        @test isnan(PureLibm.cr_compoundn(T(NaN), T(NaN)))
        # — compoundn(x, 0) returns 1
        #   for x ≥ −1 or x a NaN.
        # — compoundn(x, n) returns a NaN and raises the "invalid" floating-point exception
        #   for x < −1.
        # — compoundn(−1, n) returns +∞ and raises the divide-by-zero floating-point exception
        #   for n < 0.
        # — compoundn(−1, n) returns +0
        #   for n > 0.
        # — compoundn(±∞, n) returns +∞
        #   for n > 0.
        # — compoundn(±∞, n) returns +0
        #   for n < 0.

    end
end
