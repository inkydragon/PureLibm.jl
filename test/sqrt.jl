# SPDX-License-Identifier: MIT OR Apache-2.0

# for T in [Float32, Float64]
#     @testset "musl_sqrt(::$T)" begin
#         # IEC 60559
#         @test isnan(PureLibm.musl_sqrt(T(-1.0)))
#         @test isnan(PureLibm.musl_sqrt(T(-Inf)))
#         # @test_throws DomainError PureLibm.musl_sqrt(T(-1.0))
#         @test PureLibm.musl_sqrt(T(Inf)) == T(Inf)
#         @test PureLibm.musl_sqrt(T(0.0)) == T(0.0)
#         @test PureLibm.musl_sqrt(T(-0.0)) == T(0.0)
#         @test isnan(PureLibm.musl_sqrt(T(NaN)))
        
#         # sanity check
#         @test PureLibm.musl_sqrt(T(100.0)) == T(10.0)
#         @test PureLibm.musl_sqrt(T(4.0)) == T(2.0)
#     end
# end
