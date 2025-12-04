# SPDX-License-Identifier: MIT OR Apache-2.0

for T in (Float32, )
    @testset "cr_sqrt($T)" begin
        float_gen = Data.Floats{T}(; nans=false, infs=true)

        # IEC 60559
        @test isnan(PureLibm.cr_sqrt(T(NaN)))
        # sqrt(±0) returns ±0
        @test PureLibm.cr_sqrt(T(0.0)) == T(0.0)
        @test PureLibm.cr_sqrt(T(-0.0)) == -T(0.0)
        # sqrt(+∞) returns +∞
        @test PureLibm.cr_sqrt(T(Inf)) == T(Inf)
        # sqrt(x) returns a NaN and raises the "invalid" floating-point exception
        #   for x < 0
        # @test isnan(PureLibm.cr_sqrt(T(-1.0)))
        # @test isnan(PureLibm.cr_sqrt(T(-Inf)))
        # @testset "sqrt(x) = NaN, for x < 0" begin
        #     f_domain = filter(x -> x < 0, float_gen)
        #     @check sqrt_domain(f = f_domain) = isnan(PureLibm.cr_sqrt(f))
        # end
    end
end
