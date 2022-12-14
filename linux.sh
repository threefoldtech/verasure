#!/usr/bash

# build library
gcc jerasure-simple.c -shared -Wl,-soname,libjerasuresimple.so -o libjerasuresimple.so -I/usr/include/jerasure -fpic

# build jeratest.c with the library
gcc jeratest.c -o jeratest -I/usr/include/jerasure -lJerasure -lm -L/mnt/jerasure-simple -ljerasuresimple -lm -lJerasure

# build v version
LDFLAGS="-L$(pwd) -ljerasuresimple -lJerasure -lm" v -cg jeratest.v
