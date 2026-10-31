
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
static int32_t n;
#define K (-5)

int32_t main(void) {
	const int32_t a = -n;
	const int32_t b = -(-n);
	#define c (-(-5))
	#define d (-K)
	return 0;
	#undef c
	#undef d
}

