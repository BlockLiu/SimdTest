#include <x86intrin.h>
#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

int main()
{
	alignas(16) short a[8];
	alignas(16) short b[8];
	for(int i = 0; i < 8; ++i){
		a[i] = i;
		b[i] = 8 - i;
	}

	__m128i m = _mm_add_epi16(*(__m128i*)b, *(__m128i*)a);
	_mm_store_si128((__m128i*)a, m);

	for(int i = 0; i < 8; ++i)
		printf("a[%d]=%d\n", i, a[i]);
	return 0;
}