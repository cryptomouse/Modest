
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
static int32_t a[4] = {1, 2, 3, 4};

int main(void) {
	const uint64_t adr = (uint64_t)&a[0];
	printf("adr = %llu\n", adr);
	return 0;
}

