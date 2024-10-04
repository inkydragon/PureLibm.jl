
@testset "sqrt(::Float32)" begin
    T = Float32

    # IEC 60559
    @test isnan(PureLibm.sqrt(T(-1.0)))
    @test isnan(PureLibm.sqrt(T(-Inf)))
    # @test_throws DomainError PureLibm.sqrt(T(-1.0))
    @test PureLibm.sqrt(T(Inf)) == T(Inf)
    @test PureLibm.sqrt(T(0.0)) == T(0.0)
    @test PureLibm.sqrt(T(-0.0)) == T(0.0)
    @test isnan(PureLibm.sqrt(T(NaN)))
    
    # sanity check
    @test PureLibm.sqrt(T(100.0)) == T(10.0)
    @test PureLibm.sqrt(T(4.0)) == T(2.0)
end

@testset "sqrt(::Float64)" begin
    # TODO
end
