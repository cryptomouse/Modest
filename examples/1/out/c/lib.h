
#if !defined(LIB_H)
#define LIB_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "fixed.h"
#define LIB_FREEZING_POINT (FIXED32(0.0, 16))
#define LIB_NORMAL_POINT (FIXED32(+25.0, 16))
typedef int32_t lib_Int;
typedef lib_Int lib_Y;
struct lib_x {
	lib_Int a;
	lib_Int b;
};
#endif

