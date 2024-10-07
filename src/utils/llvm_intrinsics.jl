# SPDX-License-Identifier: MIT OR Apache-2.0
# doc: https://releases.llvm.org/15.0.0/docs/LangRef.html

"""
    _llvm_clz(x)

Counts the number of leading zeros in `x`.

```c
// llvm
declare i8   @llvm.ctlz.i8  (i8   <src>, i1 <is_zero_poison>)
@llvm.ctlz.*

// gcc
int __builtin_clz   (unsigned int x)
int __builtin_clzl  (unsigned long)
int __builtin_clzll (unsigned long long)
```
"""
_llvm_clz
# declare i32   @llvm.ctlz.i32  (i32   <src>, i1 <is_zero_poison>)
_llvm_clz(x::Int32) = ccall("llvm.ctlz.i32", llvmcall, Int32, (Int32, Bool), x, true)
# declare i64   @llvm.ctlz.i64  (i64   <src>, i1 <is_zero_poison>)
_llvm_clz(x::Int64) = ccall("llvm.ctlz.i64", llvmcall, Int64, (Int64, Bool), x, true)
_llvm_clz(x::UInt32) = _llvm_clz(reinterpret(Int32, x))
_llvm_clz(x::UInt64) = _llvm_clz(reinterpret(Int64, x))

"""
    _llvm_roundeven(x)

Round `x` to the nearest integer in floating-point format rounding halfway cases to even.

```c
// llvm
declare float     @llvm.roundeven.f32(float  %Val)
declare double    @llvm.roundeven.f64(double %Val)
declare x86_fp80  @llvm.roundeven.f80(x86_fp80  %Val)
declare fp128     @llvm.roundeven.f128(fp128 %Val)

// gcc
__builtin_roundeven
__builtin_roundevenf
__builtin_roundevenl
```
"""
_llvm_roundeven
# declare float     @llvm.roundeven.f32(float  %Val)
@inline _llvm_roundeven(x::Float32) = ccall("llvm.roundeven.f32", llvmcall, Float32, (Float32,), x)
# declare double    @llvm.roundeven.f64(double %Val)
@inline _llvm_roundeven(x::Float64) = ccall("llvm.roundeven.f64", llvmcall, Float64, (Float64,), x)
