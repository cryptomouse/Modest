
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"
struct point {__fixed32 x; __fixed32 y;};
#define POINTX {.x = 1.0, .y = 2.0}
static struct point p = (struct point){.x = FIXED32(1.0, 16), .y = FIXED32(2.0, 16)};

int main(void) {
	printf("Hello World!\n");
	return 0;
}

