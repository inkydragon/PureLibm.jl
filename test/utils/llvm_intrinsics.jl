# SPDX-License-Identifier: MIT OR Apache-2.0

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
