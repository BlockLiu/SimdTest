#include <x86intrin.h>
#include <xmmintrin.h> // SSE
#include <emmintrin.h> // SSE2
#include <pmmintrin.h> // SSE3
#include <tmmintrin.h> // SSSE3
#include <immintrin.h> // AVX
// #include <zmmintrin.h> // AVX512
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <algorithm>
using namespace std;

#define SIZE 32
int main(int argc, char *argv[])
{
    assert(argc > 1);
    int subVal = atoi(argv[1]);

    uint16_t *counters = new uint16_t[SIZE];

	  uint8_t *a = new uint8_t[SIZE];
    uint8_t *b = new uint8_t[SIZE];
    uint8_t *c = new uint8_t[SIZE];
	  for(int i = 0; i < SIZE; ++i){
		    a[i] = i % 2 == 1 ? i : 0;
        b[i] = std::max(0, subVal - 1);
        c[i] = std::max(0, subVal);
        counters[i] = (i * i) % 65536;
	  }

    printf("clock:\n");
    for(int i = 0; i < SIZE; ++i){
		printf("a[%.2d]=%.2u\t", i, (unsigned int)(a[i]));
        if(i % 8 == 7)
            printf("\n");
    }
    printf("\nCounters:\n");
    for(int i = 0; i < SIZE; ++i){
		printf("a[%.2d]=%.2u\t", i, (unsigned int)(counters[i]));
        if(i % 8 == 7)
            printf("\n");
    }
    printf("\n");

    __m256i m2 =  _mm256_set1_epi8(char(subVal - 1));     // m2 is all subVal-1
    __m256i m3 =  _mm256_set1_epi8(char(subVal));     // m3 is subVal
    for(int i = 0; i < SIZE; i += 32){
        __m256i m1 = _mm256_loadu_si256((__m256i*)(&a[i]));     // load instructions
        __m256i m4 = _mm256_subs_epu8(m1, m3);
        _mm256_storeu_si256((__m256i*)(&a[i]), m4);

        __m256i x = _mm256_max_epu8(m1, m2);     // find out those < subVal, and set those to subVal-1
        __m256i eq = _mm256_cmpeq_epi8(x, m2);   // find out those subVal-1
        
        __m128i low128 = _mm256_extracti128_si256(eq, 0);
        __m128i high128 = _mm256_extracti128_si256(eq, 1);
        __m256i low = _mm256_cvtepi8_epi16(low128);
        __m256i high = _mm256_cvtepi8_epi16(high128);           // pack datas for update counters

        __m256i cLow = _mm256_loadu_si256((__m256i*)(&counters[i]));
        __m256i cHigh = _mm256_loadu_si256((__m256i*)(&counters[i + 16]));  // load counter datas

        __m256i resLow = _mm256_andnot_si256(low, cLow);
        __m256i resHigh = _mm256_andnot_si256(high, cHigh);     
        _mm256_storeu_si256((__m256i*)(&counters[i]), resLow);
        _mm256_storeu_si256((__m256i*)(&counters[i + 16]), resHigh);   // update counters
    }

    printf("clock:\n");
	  for(int i = 0; i < SIZE; ++i){
		printf("a[%.2d]=%.2u\t", i, (unsigned int)(a[i]));
        if(i % 8 == 7)
            printf("\n");
    }
    printf("\nCounters:\n");
    for(int i = 0; i < SIZE; ++i){
		printf("a[%.2d]=%.2u\t", i, (unsigned int)(counters[i]));
        if(i % 8 == 7)
            printf("\n");
    }
    printf("\n");

    delete[] a;
    delete[] b;
    delete[] c;
    delete counters;
	  return 0;
}
