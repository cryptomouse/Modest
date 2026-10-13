
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
struct aligned {
	uint8_t a;
} __attribute__((deprecated));
static uint32_t num;

static uint32_t getnum(void) {
	const uint32_t n = num;
	++num;
	return n;
}

static bool checkArgs(uint32_t a, uint32_t b, uint32_t c) {
	return a < b && b < c;
}

static bool checkArray(uint32_t *_a) {
	uint32_t a[3];
	__builtin_memcpy(a, _a, sizeof(uint32_t [3]));
	return a[0] < a[1] && a[1] < a[2];
}
struct triple {uint32_t a; uint32_t b; uint32_t c;};

static bool checkRecord(struct triple r) {
	return r.a < r.b && r.b < r.c;
}

int32_t main(void) {
	struct aligned a = {0};
	const bool c0 = checkArgs(getnum(), getnum(), getnum());
	printf("checkArgs() = %d\n", c0);
	const bool c1 = checkArray((uint32_t [3]){getnum(), getnum(), getnum()});
	printf("checkArray() = %d\n", c1);
	const bool c2 = checkRecord((struct triple){.a = getnum(), .b = getnum(), .c = getnum()});
	printf("checkRecord() = %d\n", c2);
	const bool c3 = checkRecord((struct triple){.c = getnum(), .b = getnum(), .a = getnum()});
	printf("checkRecord(reversed) = %d\n", c3);
	return 0;
}

