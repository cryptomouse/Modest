
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
#define C1 1
#define C2 2

static int32_t sum(int32_t a, int32_t b) {
	return a + b;
}
#define C3 3

static int32_t init(void) {
	const int32_t a = 3;
	printf("sum: %d\n", a);
	return 0;
}

int32_t main(void) {
	init();
	const int32_t a = 3;
	return 0;
}

