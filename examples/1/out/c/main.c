
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
static int32_t n;
struct ref {int32_t tag; int32_t *p;};
static struct ref rs[2] = {{.tag = 1, .p = &n}, {.tag = 2, .p = NULL}};

int32_t main(void) {
	return 0;
}

