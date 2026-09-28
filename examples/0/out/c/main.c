
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"
struct point {__fixed32 x; __fixed32 y;};
#define GENERIC_POINT {.x = 1.0, .y = 2.0}
#define CONSTANT_POINT ((struct point){.x = FIXED32(1.0, 16), .y = FIXED32(2.0, 16)})
static struct point variablePoint = (struct point){.x = FIXED32(1.0, 16), .y = FIXED32(2.0, 16)};


int main(void) {
	printf("Hello World!\n");
	const uint8_t x = (uint8_t)((uint32_t)5 & 0xFF);
	printf("constantPoint = {x=%f, y=%f}\n", (float)__FIXED32_TO_FLOAT64(CONSTANT_POINT.x, 16), (float)__FIXED32_TO_FLOAT64(CONSTANT_POINT.y, 16));
	printf("variablePoint = {x=%f, y=%f}\n", (float)__fixed32_to_float64(variablePoint.x, 16), (float)__fixed32_to_float64(variablePoint.y, 16));
	int32_t a[5] = {1, 2, 3, 4, 5};
	const int32_t y = (&a[1])[0];
	printf("y = %d\n", y);
	return 0;
}

