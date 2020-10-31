#!/bin/sh

g++ -o noSimd -O0 noSimd.cpp -g -std=c++11
objdump -S noSimd > noSimd.asm

g++ -o simd -O0 simd.cpp -g -std=c++11
objdump -S simd > simd.asm