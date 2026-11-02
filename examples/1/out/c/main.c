
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
static uint32_t a[10][20];
static uint32_t k = 10;
static uint32_t l = 20;

int32_t main(void) {
	void *const p = (void *)a;
	const uint32_t __MyArray_0 = k;
	const uint32_t __MyArray_1 = l;
	typedef uint32_t MyArray[__MyArray_0][__MyArray_1];
	k = 0;
	l = 0;
	uint32_t (*const pa)[__MyArray_1] = (uint32_t (*)[__MyArray_1])p;
	printf("sizeof(MyArray) = %d\n", sizeof(uint32_t) * __MyArray_1 * __MyArray_0);
	printf("sizeof(*pa) = %d\n", sizeof(uint32_t) * __MyArray_1 * __MyArray_0);
	return 0;
}

