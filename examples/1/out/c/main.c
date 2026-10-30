
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"
//include "./lib"
struct r {__fixed32 a; __fixed32 b;};
static struct r t[2] = {
	(struct r){.a = FIXED32(1.0, 16)},
	(struct r){.a = FIXED32(1.0, 16), .b = FIXED32(0.5, 16)}
};

int32_t main(void) {
	return 0;
}

