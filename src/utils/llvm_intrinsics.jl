# SPDX-License-Identifier: MIT OR Apache-2.0
# doc: https://releases.llvm.org/15.0.0/docs/LangRef.html

"__builtin_clzll"
@inline _llvm_clz(x::Int64) =
    # declare i64   @llvm.ctlz.i64  (i64   <src>, i1 <is_zero_poison>)
    ccall("llvm.ctlz.i64", llvmcall, Int64, (Int64, Bool), x, true)

"""
__builtin_roundeven
"""
_llvm_roundeven
# declare float     @llvm.roundeven.f32(float  %Val)
@inline _llvm_roundeven(x::Float32) = ccall("llvm.roundeven.f32", llvmcall, Float32, (Float32,), x)
# declare double    @llvm.roundeven.f64(double %Val)
@inline _llvm_roundeven(x::Float64) = ccall("llvm.roundeven.f64", llvmcall, Float64, (Float64,), x)
