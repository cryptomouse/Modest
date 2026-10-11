
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
struct aligned {
	uint8_t a;
};

int32_t main(void) {
	int32_t i = 5;
	printf("alignof = %zu\n", __alignof(struct aligned));
	printf("sizeof = %zu\n", sizeof(struct aligned));
	return 0;
}

