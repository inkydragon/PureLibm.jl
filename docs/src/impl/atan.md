# atan notes

## atanf

polynomials generated using rminimax

```sh
./ratapprox --function="atan(x)" \
    --dom=[0.000122070,1] \
    --num=[x,x^3,x^5,x^7,x^9,x^11,x^13] \
    --den=[1,x^2,x^4,x^6,x^8,x^10,x^12] \
    --output=atanf.sollya --log
```

Output:

```c
================ADIFFCORR FINISH=================

Location        Maximum error
0.501899        5.80879e-18
Error norm = 5.80879e-18
DC    norm = 5.80879e-18

Final coefficients:
Numerator:
0.330122 0.827135 0.753632 0.304029 0.052552 0.00308965 2.6641e-05
Denominator:
0.330122 0.937176 1 0.497088 0.11545 0.010893 0.000272885
Starting fpminimax...
Finished fpminimax...
-----------------------INFORMATION--------------------
Function = atan(x)
Weight = reciprocal of atan(x)
Domain: [0.00012207, 1]
Numerator basis = x,x^3,x^5,x^7,x^9,x^11,x^13
Denominator basis = 1,x^2,x^4,x^6,x^8,x^10,x^12
Approximation error                              = 5.80879e-18
Naive rounding approximation error               = 3.80928e-17
fpminimax approximation error                    = 6.47925e-18
------------------------------------------------------
Writing results to the file atanf.sollya

Disabling EG-GMP mempool
root@75d37cef8a52:/home/rminimax/build# cat atanf.sollya
Numerator = [|
0x5.47b33781d759cp-4,
0xd.3b5dab1bf979p-4,
0xc.0f0776906f44p-4,
0x4.ddb23299f4474p-4,
0xd.763db4901563p-8,
0xc.ab0c4cd6639fp-12,
0x1.bf9fa5b67e6p-16|];
Denominator = [|
0x5.47b33781d759cp-4,
0xe.fdeebd9c9694p-4,
0x1p+0,
0x7.f48afc3a26d5p-4,
0x1.d91ff8b576282p-4,
0x2.ca7d533f9376p-8,
0x1.1e7fcc202340ap-12|];
```

Note: the coefficients need to be normalized:

```jl
julia> num = [
       0x5.47b33781d759cp-4,
       0xd.3b5dab1bf979p-4,
       0xc.0f0776906f44p-4,
       0x4.ddb23299f4474p-4,
       0xd.763db4901563p-8,
       0xc.ab0c4cd6639fp-12,
       0x1.bf9fa5b67e6p-16
       ];

julia> den = [
       0x5.47b33781d759cp-4,
       0xe.fdeebd9c9694p-4,
       0x1p+0,
       0x7.f48afc3a26d5p-4,
       0x1.d91ff8b576282p-4,
       0x2.ca7d533f9376p-8,
       0x1.1e7fcc202340ap-12
       ];

julia> using Printf

julia> [@printf("%a\n", x) for x in num];
0x1.51eccde075d67p-2
0x1.a76bb5637f2f2p-1
0x1.81e0eed20de88p-1
0x1.376c8ca67d11dp-2
0x1.aec7b69202ac6p-5
0x1.9561899acc73ep-9
0x1.bf9fa5b67e6p-16

julia> [@printf("%a\n", x) for x in den];
0x1.51eccde075d67p-2
0x1.dfbdd7b392d28p-1
0x1p+0
0x1.fd22bf0e89b54p-2
0x1.d91ff8b576282p-4
0x1.653ea99fc9bbp-7
0x1.1e7fcc202340ap-12
```
