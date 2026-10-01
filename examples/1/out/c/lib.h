
#if !defined(LIB_H)
#define LIB_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "fixed.h"
typedef __fixed32 lib_Celsius;
#define LIB_FREEZING_POINT (FIXED32(0.0, 16))
#define LIB_NORMAL_POINT (FIXED32(+25.0, 16))
#endif

