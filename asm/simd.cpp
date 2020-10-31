#include <x86intrin.h>
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

int main()
{
	short a[8], b[8];
	for(int i = 0; i < 8; ++i){
		a[i] = i;
		b[i] = 8 - i;
	}

	// __m128i m2 = _mm_load_si128((__m128i*)b);
	// __m128i m1 = _mm_load_si128((__m128i*)a);
	__m128i m = _mm_add_epi16(*(__m128i*)b, *(__m128i*)a);
	_mm_store_si128((__m128i*)a, m);

	for(int i = 0; i < 8; ++i)
		printf("a[%d]=%d\n", i, a[i]);
	return 0;
}