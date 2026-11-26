
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

static int32_t sum(int32_t a, int32_t b) {
	return a + b;
}
#define K 3

int32_t main(void) {
	int32_t k = sum(1, 2);
	return 0;
}

