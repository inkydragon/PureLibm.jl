# SPDX-License-Identifier: MIT OR Apache-2.0
# doc: https://releases.llvm.org/15.0.0/docs/LangRef.html

"__builtin_clzll"
@inline _llvm_clz(x::Int64) =
    # declare i64   @llvm.ctlz.i64  (i64   <src>, i1 <is_zero_poison>)
    ccall("llvm.ctlz.i64", llvmcall, Int64, (Int64, Bool), x, true)
