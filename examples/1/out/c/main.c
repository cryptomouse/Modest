
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#define RAWCAST(type_dst, type_src, value) (((union { type_src src; type_dst dst; }){ .src = (value) }).dst)
//include "./lib"

int main(void) {
	struct point {int32_t x; int32_t y;};
	typedef struct brand Brand;
	struct brand {int32_t x; int32_t y;};
	struct point p = (struct point){.x = 1, .y = 2};
	Brand b = RAWCAST(Brand, struct point, p);
	struct point q = RAWCAST(struct point, Brand, b);
	return 0;
}

