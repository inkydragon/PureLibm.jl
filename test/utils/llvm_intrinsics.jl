# SPDX-License-Identifier: MIT OR Apache-2.0

@testset "_llvm_clz" begin
    # Int32
    @test PureLibm._llvm_clz(UInt32(1)) == 31
    @test PureLibm._llvm_clz(typemax(UInt32)) == 0
    @test PureLibm._llvm_clz(typemax(UInt32) >> 1) == 1

    # Int64
    @test PureLibm._llvm_clz(UInt64(1)) == 63
    @test PureLibm._llvm_clz(typemax(UInt64)) == 0
    @test PureLibm._llvm_clz(typemax(UInt64) >> 1) == 1
end

for T in [Float32, Float64]
    @testset "_llvm_roundeven(::$T)" begin
        # IEC 60559
        @test PureLibm._llvm_roundeven(T(+0.0)) === T(+0.0)
        @test PureLibm._llvm_roundeven(T(-0.0)) === T(-0.0)
        @test PureLibm._llvm_roundeven(T(+Inf)) === T(+Inf)
        @test PureLibm._llvm_roundeven(T(-Inf)) === T(-Inf)
        @test isnan(PureLibm._llvm_roundeven(T(NaN)))

        # sanity check
        @test PureLibm._llvm_roundeven(T(1.4)) === T(1.0)
        @test PureLibm._llvm_roundeven(T(1.5)) === T(2.0)
        @test PureLibm._llvm_roundeven(T(1.6)) === T(2.0)
        @test PureLibm._llvm_roundeven(T(2.4)) === T(2.0)
        @test PureLibm._llvm_roundeven(T(2.5)) === T(2.0)
        @test PureLibm._llvm_roundeven(T(2.6)) === T(3.0)
        @test PureLibm._llvm_roundeven(T(-0.5)) === T(-0.0)
    end
end

@testset "_llvm_popcount" begin
    # UInt32
    @test PureLibm._llvm_popcount(UInt32(0)) == 0
    @test PureLibm._llvm_popcount(typemax(UInt32)) == 32
    @test PureLibm._llvm_popcount(typemax(UInt32) >> 1) == 31

    # UInt64
    @test PureLibm._llvm_popcount(UInt64(0)) == 0
    @test PureLibm._llvm_popcount(typemax(UInt64)) == 64
    @test PureLibm._llvm_popcount(typemax(UInt64) >> 1) == 63
end
