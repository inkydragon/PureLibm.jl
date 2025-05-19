# IEEE Std 754-2019

## Additional mathematical operations

```c
// Table 9.1—Additional mathematical operations
exp
expm1
exp2
exp2m1
exp10
exp10m1

log
log2
log10

logp1
log2p1
log10p1

hypot(x, y)

rSqrt

compound(x, n)

rootn(x, n)

pown(x, n)
pow(x, y)
powr(x, y)

sin
cos
tan
sinPi
cosPi
tanPi

asin
acos
atan
atan2( y, x)
asinPi
acosPi
atanPi
atan2Pi( y, x)

sinh
cosh
tanh
asinh
acosh
atanh
```


## General operations

| IEC 60559 operation        |              C operation | julia op      | Clause       |
|:---------------------------|-------------------------:|:--------------|:-------------|
| class                      |               fpclassify | ❌             | 7.12.3.1     |
| class                      |                `signbit` | ✅             | 7.12.3.7     |
| class                      |              issignaling | ❌             | 7.12.3.8     |
| isSignMinus                |                `signbit` | ✅             | 7.12.3.7     |
| isNormal                   |                 isnormal | ❌             | 7.12.3.6     |
| isFinite                   |               `isfinite` | ✅             | 7.12.3.3     |
| isZero                     |                 `iszero` | ✅             | 7.12.3.10    |
| isSubnormal                |            `issubnormal` | ✅             | 7.12.3.9     |
| isInfinite                 |                  `isinf` | ✅             | 7.12.3.4     |
| isNaN                      |                  `isnan` | ✅             | 7.12.3.5     |
| isSignaling                |              issignaling | ❌             | 7.12.3.8     |
| isCanonical                |              iscanonical | ❌             | 7.12.3.2     |
| radix                      |              `FLT_RADIX` | ❌             | 5.2.4.2.2    |
| totalOrder                 |               totalorder | ❌             | F.10.12.1    |
| totalOrderMag              |            totalordermag | ❌             | F.10.12.2    |
| lowerFlags                 |            feclearexcept | ❌             | 7.6.4.1      |
| raiseFlags                 |              fesetexcept | ❌             | 7.6.4.4      |
| testFlags                  |             fetestexcept | ❌             | 7.6.4.7      |
| testSavedFlags             |         fetestexceptflag | ❌             | 7.6.4.6      |
| restoreFlags               |          fesetexceptflag | ❌             | 7.6.4.5      |
| saveAllFlags               |          fegetexceptflag | ❌             | 7.6.4.2      |
| getBinaryRoundingDirection |               fegetround | `rounding`     | 7.6.5.2      |
| setBinaryRoundingDirection |               fesetround | `setrounding`  | 7.6.5.5      |
| saveModes                  |                fegetmode | ❌             | 7.6.5.1      |
| restoreModes               |                fesetmode | ❌             | 7.6.5.4      |
| defaultModes               | fesetmode(`FE_DFL_MODE`) | ❌             | 7.6.5.4, 7.6 |

```c
// 5.7.2 General operations 5
enum class(source)
class(x) tells which of the following ten classes x falls into:
    signalingNaN
    quietNaN
    negativeInfinity
    negativeNormal
    negativeSubnormal
    negativeZero
    positiveZero
    positiveSubnormal
    positiveNormal
    positiveInfinity.

boolean isSignMinus(source)
    isSignMinus(x) is true if and only if x has negative sign. isSignMinus applies to zeros and NaNs
    as well.
boolean isNormal(source)
    isNormal(x) is true if and only if x is normal (not zero, subnormal, infinite, or NaN).
boolean isFinite(source)
    isFinite(x) is true if and only if x is zero, subnormal or normal (not infinite or NaN).
boolean isZero(source)
    isZero(x) is true if and only if x is ±0.
boolean isSubnormal(source)
    isSubnormal(x) is true if and only if x is subnormal.
boolean isInfinite(source)
    isInfinite(x) is true if and only if x is infinite.
boolean isNaN(source)
    isNaN(x) is true if and only if x is a NaN.
boolean isSignaling(source)
    isSignaling(x) is true if and only if x is a signaling NaN.
boolean isCanonical(source)
    isCanonical(x) is true if and only if x is a finite number, infinity, or NaN that is canonical.
    Implementations should extend isCanonical(x) to formats that are not interchange formats in
    ways appropriate to those formats, which might, or might not, have finite numbers, infinities, or
    NaNs that are non-canonical.

enum radix(source)
    radix(x) is the radix b of the format of x, that is, two or ten.

boolean totalOrder(source, source)
    totalOrder(x, y) is defined in 5.10.
boolean totalOrderMag(source, source)
    totalOrderMag(x, y) is totalOrder(abs(x), abs(y)).
```
