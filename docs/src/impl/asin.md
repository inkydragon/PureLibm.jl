# ASIN

## MegaLibm

[Mega][megalibm]

```c
|x| <= 0.5:     polynomial to approx
|x| <= 1.:      asin(x) = pi/2 - 2*asin(sqrt((1 - x) / 2))
```

## llvm

[`asinf.cpp`][llvm]

```c
|x| <  2^-12
|x| <= 0.5:     asin(x) = x * P(x^2)
|x| <= 1.:      asin(x) = y = pi/2 - 2 * asin( sqrt( (1 - x)/2 ) )
|x| >  1.:      NaN
```

## OpenLibm

[`e_asin.c`][openlibm]

```c
|x| <  0.5:     asin(x) = x + x*x^2*R(x^2)
|x| <  0.975:   asin(x) = pi/2 - 2*(s+s*z*R(z))
|x| <= 1.:      asin(x) = pi/2 - 2*(s+s*z*R(z))
|x| >  1.:      NaN
```

## Glibc

[`e_asin.c`][glibc]

```c
|x| < 2^-26
|x| < 0.125
|x| < 0.5
|x| < 0.75
|x| < 0.921875
|x| < 0.953125
|x| < 0.96875
|x| < 1
|x| >= 1
```

## ref

[megalibm]: https://pavpanchekha.com/blog/megalibm.html#org1c55811
[llvm]: https://github.com/llvm/llvm-project/blob/main/libc/src/math/generic/asinf.cpp
[openlibm]: https://github.com/JuliaMath/openlibm/blob/master/src/e_asin.c
[glibc]: https://github.com/steezer/glibc-src/blob/master/sysdeps/ieee754/dbl-64/e_asin.c
