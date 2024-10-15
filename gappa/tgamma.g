#!/usr/bin/gappa
# musl
# https://github.com/bminor/musl/blob/047a16398b29d2702a41a0d6d15370d54b9d723c/src/math/tgamma.c#L108

@rnd = float< ieee_32, ne >;
y rnd= x * (1 - x);
z = x * (1 - x);

{ x in [0,1] -> y in ? /\ y - z in ? }