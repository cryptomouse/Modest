
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "fixed.h"
static float f32 = 0.0;
static double f64 = 0.0;
static __fixed32 fx32 = FIXED32(0.0, 16);
static __fixed64 fx64 = FIXED64(0.0, 32);
#define C 1.5
static __fixed64 arr[10] = {FIXED64(1.5, 32), FIXED64(2.5, 32)};


int main(void) {
	printf("Hello World!\n");
	f32 = (float)1.0;
	f64 = 1.0;
	fx32 = FIXED32(1, 16);
	fx64 = FIXED64(1, 32);
	printf("fx32 = 0x%08x\n", fx32);
	printf("fx64 = 0x%016llx\n", fx64);
	fx32 = FIXED32(C, 16);
	fx64 = FIXED64(C, 32);
	printf("fx32 = 0x%08x\n", fx32);
	printf("fx64 = 0x%016llx\n", fx64);
	const __fixed32 c2 = FIXED32(1.5, 16);
	const __fixed32 c3 = __FIXED32_DIV(c2, FIXED32(2, 16), 16);
	printf("c3 = 0x%08x\n", c3);
	printf("c3 = %lf\n", __FIXED32_TO_FLOAT64(c3, 16));
	__fixed32 v1 = c3;
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div((v1 + FIXED32(1, 16)), FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	v1 = __fixed32_div(v1, FIXED32(2, 16), 16);
	printf("v1 = %lf\n", __fixed32_to_float64(v1, 16));
	return 0;
}

