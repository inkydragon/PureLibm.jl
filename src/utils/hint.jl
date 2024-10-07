
## branch prediction annotations

"""
Hints that the condition `cond` is likely to be `true`.

```c
// Macro define in C
#define likely(x)   __builtin_expect(!!(x), 1)
```
"""
macro likely(cond)
    # TODO: Maybe use `@llvm.expect.i1`
    # declare i1 @llvm.expect.i1(i1 <val>, i1 <expected_val>)
    return :( $(esc(cond)) )
end

"""
Hints that the condition `cond` is likely to be `false`.

```c
// Macro define in C
#define unlikely(x) __builtin_expect(!!(x), 0)
```
"""
macro unlikely(cond)
    return :( $(esc(cond)) )
end
