# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_pow($T)" begin
        #= IEC 60559 =#
        @test isnan(PureLibm.cr_pow(T(0), T(NaN)))
        @test isnan(PureLibm.cr_pow(T(NaN), T(NaN)))
        # — pow(±0, y) returns ±∞ and raises the "divide-by-zero" floating-point exception
        #   for y an odd integer < 0
        # — pow(±0, y) returns +∞ and raises the "divide-by-zero" floating-point exception
        #   for y < 0, finite, and not an odd integer
        # — pow(±0, −∞) returns +∞
        @test PureLibm.cr_pow(T(0), -T(Inf)) == T(Inf)
        @test PureLibm.cr_pow(-T(0), -T(Inf)) == T(Inf)
        # — pow(±0, y) returns ±0 for y an odd integer > 0
        # — pow(±0, y) returns +0 for y > 0 and not an odd integer
        # — pow(−1, ±∞) returns 1
        @test PureLibm.cr_pow(-T(1), T(Inf)) == T(1)
        @test PureLibm.cr_pow(-T(1), -T(Inf)) == T(1)
        # — pow(+1, y) returns 1 for any y, even a NaN
        # — pow(x, ±0) returns 1 for any x, even a NaN
        @test PureLibm.cr_pow(T(NaN), T(0)) == T(1)
        @test PureLibm.cr_pow(T(NaN), -T(0)) == T(1)
        # — pow(x, y) returns a NaN and raises the "invalid" floating-point exception
        #   for finite x < 0 and finite non-integer y
        # — pow(x, −∞) returns +∞ for |x| < 1
        # — pow(x, −∞) returns +0 for |x| > 1
        # — pow(x, +∞) returns +0 for |x| < 1
        # — pow(x, +∞) returns +∞ for |x| > 1
        # — pow(−∞, y) returns −0 for y an odd integer < 0
        # — pow(−∞, y) returns +0 for y < 0 and not an odd integer
        # — pow(−∞, y) returns −∞ for y an odd integer > 0
        # — pow(−∞, y) returns +∞ for y > 0 and not an odd integer
        # — pow(+∞, y) returns +0 for y < 0
        # — pow(+∞, y) returns +∞ for y > 0
    end
end
