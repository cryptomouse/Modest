
#if !defined(LIB_H)
#define LIB_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "fixed.h"
typedef __fixed32 lib_Celsius;
#define LIB_FREEZING_POINT (FIXED32(0.0, 16))
#define LIB_NORMAL_POINT (FIXED32(+25.0, 16))
typedef int32_t lib_LocalInt;
extern lib_LocalInt lib_x;
typedef lib_LocalInt lib_Int;
typedef lib_Int lib_Y;
typedef struct lib_x lib_X;
struct lib_x {
	lib_LocalInt a;
	lib_LocalInt b;
	lib_LocalInt c;
};
// public func f (p: {x: LocalInt}) -> Unit {
// }
#endif

