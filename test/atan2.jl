# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_atan2(::$T)" begin
        t_neg = -rand(T)
        t_pos = rand(T)

        # IEC 60559
        # special y
        #   atan2(±0, −0) returns ±π
        @test PureLibm.cr_atan2(T(+0.0), T(-0.0)) ≈ +π
        @test PureLibm.cr_atan2(T(-0.0), T(-0.0)) ≈ -π
        #   atan2(±0, +0) returns ±0
        @test PureLibm.cr_atan2(T(+0.0), T(+0.0)) === T(+0.0)
        @test PureLibm.cr_atan2(T(-0.0), T(+0.0)) === T(-0.0)
        #   atan2(±0, x) returns ±π for x < 0
        @test PureLibm.cr_atan2(T(+0.0), t_neg) ≈ +π
        @test PureLibm.cr_atan2(T(-0.0), t_neg) ≈ -π
        #   atan2(±0, x) returns ±0 f or x > 0
        @test PureLibm.cr_atan2(T(+0.0), t_pos) === T(+0.0)
        @test PureLibm.cr_atan2(T(-0.0), t_pos) === T(-0.0)

        # special x
        #   atan2(y, ±0) returns −π /2 for y < 0
        @test PureLibm.cr_atan2(t_neg, T(+0.0)) ≈ -π/2
        @test PureLibm.cr_atan2(t_neg, T(-0.0)) ≈ -π/2
        #   atan2(y, ±0) returns π /2 for y > 0
        @test PureLibm.cr_atan2(t_pos, T(+0.0)) ≈ π/2
        @test PureLibm.cr_atan2(t_pos, T(-0.0)) ≈ π/2
        #   atan2(±y, −∞) returns ±π for finite y > 0
        @test PureLibm.cr_atan2(t_pos, T(-Inf)) ≈ +π
        @test PureLibm.cr_atan2(t_neg, T(-Inf)) ≈ -π
        #   atan2(±y, +∞) returns ±0 f or finite y > 0
        @test PureLibm.cr_atan2(t_pos, T(+Inf)) === T(+0.0)
        @test PureLibm.cr_atan2(t_neg, T(+Inf)) === T(-0.0)

        # test Inf
        t_finite = rand(T)
        #   atan2(±∞, x) returns ±π /2 for finite x
        @test PureLibm.cr_atan2(T(+Inf), t_finite) ≈ +π/2
        @test PureLibm.cr_atan2(T(-Inf), t_finite) ≈ -π/2
        #   atan2(±∞, −∞) returns ±3π /4
        @test PureLibm.cr_atan2(T(+Inf), T(-Inf)) ≈ +3π/4
        @test PureLibm.cr_atan2(T(-Inf), T(-Inf)) ≈ -3π/4
        #   atan2(±∞, +∞) returns ±π /4
        @test PureLibm.cr_atan2(T(+Inf), T(+Inf)) ≈ +π/4
        @test PureLibm.cr_atan2(T(-Inf), T(+Inf)) ≈ -π/4

        # test NaN
        @test isnan(PureLibm.cr_atan2(T(NaN), T(1.0)))
        @test isnan(PureLibm.cr_atan2(T(1.0), T(NaN)))
        @test isnan(PureLibm.cr_atan2(T(NaN), T(NaN)))

        # sanity check
    end
end
