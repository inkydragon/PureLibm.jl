# SPDX-License-Identifier: MIT OR Apache-2.0

# if the argument is ±0 or ±∞, it is returned, unchanged
# if the argument is NaN, NaN is returned.
# for T in [Float32, Float64]
#     @testset "musl_cbrt(::$T)" begin
#         # IEC 60559
#         @test PureLibm.musl_cbrt(T(0.0)) == T(0.0)
#         @test PureLibm.musl_cbrt(T(-0.0)) == T(-0.0)
#         @test PureLibm.musl_cbrt(T(Inf)) == T(Inf)
#         @test PureLibm.musl_cbrt(T(-Inf)) == T(-Inf)
#         @test isnan(PureLibm.musl_cbrt(T(NaN)))

#         # sanity check
#         @test PureLibm.musl_cbrt(T(1.0)) == T(1.0)
#         @test PureLibm.musl_cbrt(T(27.0)) == T(3.0)
#         @test PureLibm.musl_cbrt(T(1000.0)) == T(10.0)
#         @test PureLibm.musl_cbrt(T(-1.0)) == T(-1.0)
#         @test PureLibm.musl_cbrt(T(-1000.0)) == T(-10.0)
#     end
# end
