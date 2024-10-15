#include "klee/klee.h"

int main() {
  int c,d;
  klee_make_symbolic(&c, sizeof(c), "c");
  klee_make_symbolic(&d, sizeof(d), "d");
  
  int tmp;
  if (c == 2) 
    tmp = d == 3;
  else
    tmp = 0;

  klee_assume(tmp);

  return 0;
}
/*
clang -O0 -I klee_path/include/ -g -c -emit-llvm p.c -o p.bc
klee  p.bc
 */