# tanh notes

## tanhf

> TODO: find out why output not match

polynomials generated using rminimax

```sh
./ratapprox --function="tanh(x)" \
    --dom=[0x1p-12,9.010913] \
    --num=[x,x^3,x^5,x^7,x^9,x^11,x^13,x^15] \
    --den=[1,x^2,x^4,x^6,x^8,x^10,x^12,x^14] \
    --log --output=tanh.sollya
```

Output:

```c
================ADIFFCORR FINISH=================

Location        Maximum error
4.72199 1.79261e-17
Error norm = 1.79261e-17
DC    norm = 1.7926e-17

Final coefficients:
Numerator:
1 0.148698 0.00551317 7.65439e-05 4.47369e-07 1.06722e-09 8.35963e-13 9.39049e-17
Denominator:
1 0.482031 0.0328569 0.00072627 6.51159e-06 2.46293e-08 3.52285e-11 1.2741e-14
Starting fpminimax...
Finished fpminimax...
-----------------------INFORMATION--------------------
Function = tanh(x)
Weight = reciprocal of tanh(x)
Domain: [0.000244141, 9.01091]
Numerator basis = x,x^3,x^5,x^7,x^9,x^11,x^13,x^15
Denominator basis = 1,x^2,x^4,x^6,x^8,x^10,x^12,x^14
Approximation error                              = 1.79261e-17
Naive rounding approximation error               = 6.4631e-17
fpminimax approximation error                    = 2.5133e-17
------------------------------------------------------
Writing results to the file tanh.sollya

# cat tanh.sollya
Numerator = [|
0x1p+0,
0x2.61112864ab514p-4,
0x1.694fbb173746dp-8,
0x5.0432349fa3ddp-16,
0x7.8170936f8dea8p-24,
0x4.956c3986a2de4p-32,
0xe.b4e0db6c8209p-44,
0x6.c443e5b5e3238p-56|];
Denominator = [|
0x1p+0,
0x7.b6667dba00a58p-4,
0x8.6950377fc376p-8,
0x2.f98ced677f7d8p-12,
0x6.d3f250ecd0ed8p-20,
0x6.9c85a9f0f8084p-28,
0x2.6bc03836ec5aep-36,
0x3.9617e58e2a982p-48|];
```

Note: the coefficients need to be normalized:

```jl
julia> using Printf

julia> num = [
       0x1p+0,
       0x2.61112864ab514p-4,
       0x1.694fbb173746dp-8,
       0x5.0432349fa3ddp-16,
       0x7.8170936f8dea8p-24,
       0x4.956c3986a2de4p-32,
       0xe.b4e0db6c8209p-44,
       0x6.c443e5b5e3238p-56
       ];

julia> den = [
       0x1p+0,
       0x7.b6667dba00a58p-4,
       0x8.6950377fc376p-8,
       0x2.f98ced677f7d8p-12,
       0x6.d3f250ecd0ed8p-20,
       0x6.9c85a9f0f8084p-28,
       0x2.6bc03836ec5aep-36,
       0x3.9617e58e2a982p-48
       ];

julia> [@printf("%a\n", x) for x in num];
0x1p+0
0x1.3088943255a8ap-3
0x1.694fbb173746dp-8
0x1.410c8d27e8f74p-14
0x1.e05c24dbe37aap-22
0x1.255b0e61a8b79p-30
0x1.d69c1b6d90412p-41
0x1.b110f96d78c8ep-54

julia> [@printf("%a\n", x) for x in den];
0x1p+0
0x1.ed999f6e80296p-2
0x1.0d2a06eff86ecp-5
0x1.7cc676b3bfbecp-11
0x1.b4fc943b343b6p-18
0x1.a7216a7c3e021p-26
0x1.35e01c1b762d7p-35
0x1.cb0bf2c7154c1p-47
```
