# SPDX-License-Identifier: MIT OR Apache-2.0

for T in [Float32, ]
    @testset "cr_expm1(::$T)" begin
        # IEC 60559

    end
end

pos_range = (lo=Float32(0.0), hi=Float32(Inf))
neg_range = (lo=Float32(-0.0), hi=Float32(-Inf))
if "cr_expm1.fast" in CheckExhaustive
    @testset "cr_expm1-exhaustive.fast" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi)
    end
end
if "cr_expm1" in CheckExhaustive
    @testset "cr_expm1-exhaustive" begin
        test_float_range(expm1, PureLibm.cr_expm1, lo=pos_range.lo, hi=pos_range.hi, bigfloat=true)
        test_float_range(expm1, PureLibm.cr_expm1, lo=neg_range.lo, hi=neg_range.hi, bigfloat=true)
    end
end
# ENV["PURELIBM_CHECK_EXHAUSTIVE"] = "cr_expm1.fast,cr_expm1"
