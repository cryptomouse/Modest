
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
struct aligned {
	uint8_t a;
};

static void init(void);

int32_t main(void) {
	struct aligned a = {0};
	init();
	return 0;
}

static void init(void) {
}

