
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <math.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
// sqrt
// `include` pastes a module's names directly into scope — used for C
// bindings and library modules. `import "mymodule"` instead requires a
// `mymodule.` prefix on every name it brings in (see docs/lang).
// --- Types ------------------------------------------------------------------
//
// PascalCase for types, camelCase for everything else. Base types: Bool,
// IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
// FloatX (32/64), Str8/Str16/Str32 (= []CharX). Int/Nat/Float/... are
// C-named aliases from libc/ctypes64.
struct main_point {
	double x;
	double y;
};
typedef double main_Celsius;
typedef double main_Meters;
// newtype: distinct, never mixes with Float64
typedef uint8_t main_Color;
#define COLOR_RED ((main_Color)0)
#define COLOR_GREEN ((main_Color)1)
#define COLOR_BLUE ((main_Color)2)
typedef void main_Action(void);
// --- Globals ----------------------------------------------------------------
#define MAX_USERS 100
static uint32_t callCount = 0;
// mutable global; `let` is for function bodies only
// --- Functions --------------------------------------------------------------

__attribute__((always_inline))
static inline double distance(struct main_point a, struct main_point b) {
	const double dx = a.x - b.x;
	const double dy = a.y - b.y;
	return sqrt(dx * dx + dy * dy);
}

static int32_t sum(int32_t n) {
	int32_t total = 0;
	int32_t i = 0;
	while (i < n) {
		total += i;
		i += 1;
	}
	return total;
}

static void announce(void) {
	callCount += 1;
	printf("modest says hi (call #%u)\n", callCount);
}

static void tourValues(void) {
	#define n 42
	#define pi 3.14159
	int32_t i32 = n;
	double f64 = pi;
	printf("i32 = %d, f64 = %f\n", i32, f64);
	int32_t counter = 10;
	counter = 20;
	#define fixed 30
	printf("counter + fixed = %d\n", counter + fixed);
	const int32_t a = 1;
	const int64_t b = 2;
	const int64_t c = (int64_t)a + b;
	printf("c = %lld\n", c);
	const main_Meters height = 1.8;
	printf("height = %f\n", (double)height);
	const uint32_t big = 200;
	const uint8_t small = (uint8_t)big;
	printf("small = %u\n", small);
	char *const greeting = "Hello, Modest!";
	const char initial = 'M';
	printf("%s (starts with %c)\n", greeting, initial);
	#undef n
	#undef pi
	#undef fixed
}

static void tourBits(void) {
	uint32_t u = 0x0F;
	uint32_t v = 0x33;
	printf("u | v = %x\n", u | v);
	uint32_t narrow = 0xF0;
	uint32_t full = 0xFFFFFFF0UL;
	printf("~0x0F = %x, ~0x0000000F = %x\n", narrow, full);
	uint64_t w = (uint64_t)1 << 63;
	int64_t asInt = (int64_t)w;
	printf("w = %llx -> asInt = %lld\n", w, asInt);
}

static void tourData(void) {
	int32_t arr[5] = {1, 2, 3, 4, 5};
	int32_t copy[5];
	__builtin_memcpy(&copy, &arr, sizeof(int32_t [5]));
	copy[0] = 100;
	printf("arr[0] = %d, copy[0] = %d\n", arr[0], copy[0]);
	uint32_t i = 0;
	while (i < LENGTHOF(arr)) {
		printf("%d ", arr[i]);
		i += 1;
	}
	printf("\n");
	const struct main_point origin = (struct main_point){.x = 0.0, .y = 0.0};
	const struct main_point corner = (struct main_point){.x = 3.0, .y = 4.0};
	if (!({ const struct main_point *__eq_l = (const struct main_point *)&origin; const struct main_point *__eq_r = (const struct main_point *)&corner; __eq_l->x == __eq_r->x && __eq_l->y == __eq_r->y; })) {
		printf("distance = %f\n", distance(origin, corner));
	}
	struct main_point p = corner;
	struct main_point *pp = &p;
	pp->x = 99.0;
	*pp = (struct main_point){.x = 1.0, .y = 2.0};
	printf("p = (%f, %f)\n", p.x, p.y);
	struct main_point *none = NULL;
	if (none == NULL) {
		printf("none is nil\n");
	}
	int32_t *const pa = (int32_t *)arr;
	printf("pa[1] = %d\n", pa[1]);
}


static void tourControl(void) {
	const main_Color c = COLOR_GREEN;
	if (c == COLOR_RED) {
		printf("red\n");
	} else if (c == COLOR_GREEN) {
		printf("green\n");
	} else {
		printf("blue\n");
	}
	int32_t k = 0;
	while (k < 5) {
		k += 1;
		if (k == 3) {
			continue;
		}
		printf("k = %d\n", k);
	}
	int32_t j = 0;
	while (true) {
		if (j == 2) {
			break;
		}
		printf("j = %d\n", j);
		j += 1;
	}
	if (j > 0 && !(k < 0)) {
		printf("logic works\n");
	}
	main_Action *cb = &announce;
	cb();
	cb();
}

int main(void) {
	tourValues();
	tourBits();
	tourData();
	tourControl();
	printf("sizeof(Point) = %lu\n", sizeof(struct main_point));
	printf("sum(0..5) = %d\n", sum(5));
	return 0;
}

