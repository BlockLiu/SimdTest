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

	a[0] += b[0];
	a[1] += b[1];
	a[2] += b[2];
	a[3] += b[3];
	a[4] += b[4];
	a[5] += b[5];
	a[6] += b[6];
	a[7] += b[7];
	
	for(int i = 0; i < 8; ++i)
		printf("a[%d]=%d\n", i, a[i]);
	return 0;
}