
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
#define PREFERRED_WINDOW_WIDTH ((uint32_t)640)
#define PREFERRED_WINDOW_HEIGHT ((uint32_t)480)
static uint32_t a[10][20];
static uint32_t k = 10;
static uint32_t l = 20;

int32_t main(void) {
	void *const p = (void *)a;
	typedef uint32_t MyArray[k][l];
	uint32_t (*const pa)[l] = (uint32_t (*)[l])p;
	printf("sizeof(MyArray) = %d\n", sizeof(uint32_t) * l * k);
	printf("sizeof(*pa) = %d\n", sizeof(uint32_t) * l * k);
	return 0;
}

