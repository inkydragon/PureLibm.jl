# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32,)
    @testset "cr_atan2pi($T)" begin
        # IEC 60559
        # @test isnan(PureLibm.cr_atan2pi(T(NaN)))
        # atan2pi(±0, −0) returns ±1
        # atan2pi(±0, +0) returns ±0
        # atan2pi(±0, x) returns ±1 for x < 0
        # atan2pi(±0, x) returns ±0 for x > 0
        # atan2pi(y, ±0) returns −1/2 for y < 0
        # atan2pi(y, ±0) returns +1/2 for y > 0
        # atan2pi(±y, −∞) returns ±1 for finite y > 0
        # atan2pi(±y, +∞) returns ±0 for finite y > 0
        # atan2pi(±∞, x) returns ±1/2 for finite x.
        # atan2pi(±∞, −∞) returns ±3/4
        # atan2pi(±∞, +∞) returns ±1/4

        # sanity check
    end

    # @testset "cr_atan2pi(random)" begin
    #     test_x = T[
    #         eps(T(0.0)),
    #     ]
    #     test_x = [test_x..., -test_x...]
    #     @testset "cr_atan2pi($x)" for x in test_x
    #         # Test against system libm
    #         @test PureLibm.cr_atan2pi(x) ≈ _atan2pi(x)
    #         # Test against MPFR
    #         @test PureLibm.cr_atan2pi(x) === T(_atan2pi(BigFloat(x)))
    #     end
    # end
end
