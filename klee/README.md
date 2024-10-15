# KLEE

> KLEE Symbolic Execution Engine
>
> https://klee-se.org/


- TODO: we need klee-float  https://github.com/srg-imperial/klee-float

## Build and Install

```sh

# using Docker
#   https://klee-se.org/docker/

# install klee
docker pull klee/klee:3.1
docker run --rm -ti --ulimit='stack=-1:-1' -v $(pwd)/klee:/home/klee/libm  klee/klee:3.1

# in docker
cd libm/
# klee@44a634045817:~/libm$

# emir llvm ir
clang -O0 -I /home/klee/klee_build/include/ -g -c -emit-llvm  tgamma.c -o tgamma.bc

klee --libc=uclibc tgamma.bc
klee --libc=uclibc --posix-runtime  tgamma.bc
```


## ref

- [tiny-regex-c/formal_verification.md at master · kokke/tiny-regex-c](https://github.com/kokke/tiny-regex-c/blob/master/formal_verification.md)
