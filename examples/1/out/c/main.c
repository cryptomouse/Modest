
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "lib.h"
#include "fixed.h"
typedef __fixed32 Q1_31;
static Q1_31 globalQ1_31 = FIXED32(0.999999999, 31);
static Q1_31 globalQ1_31_2 = FIXED32(-1.0, 31);
typedef __fixed32 Q2_30;
static Q2_30 globalQ2_30 = FIXED32(1.0, 30);
static Q2_30 globalQ2_30_2 = FIXED32(-2.0, 30);


lib_Int main(void) {
	printf("freezingPoint = %f\n", (float)__FIXED32_TO_FLOAT64(LIB_FREEZING_POINT, 16));
	printf("normalPoint = %f\n", (float)__FIXED32_TO_FLOAT64(LIB_NORMAL_POINT, 16));
	printf("globalQ2_30 = %f\n", (float)__fixed32_to_float64(globalQ2_30, 30));
	printf("globalQ2_30_2 = %f\n", (float)__fixed32_to_float64(globalQ2_30_2, 30));
	return 0;
}

