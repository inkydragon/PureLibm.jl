# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_atan2($T)" begin
        # IEC 60559
        # atan2(±0, −0) returns ±π
        # atan2(±0, +0) returns ±0
        # atan2(±0, x) returns ±π for x < 0
        # atan2(±0, x) returns ±0 for x > 0
        # atan2(y, ±0) returns -π/2 for y < 0
        # atan2(y, ±0) returns π/2 for y > 0
        # atan2(±y, −∞) returns ±π for finite y > 0
        # atan2(±y, +∞) returns ±0 for finite y > 0
        # atan2(±∞, x) returns ±π/2 for finite x
        # atan2(±∞, −∞) returns ±3π/4
        # atan2(±∞, +∞) returns ±π/4

        # sanity check
    end
end
