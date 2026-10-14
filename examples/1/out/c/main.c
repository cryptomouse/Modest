
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
//include "./lib"
static char *cmd[7] = {"abc", "def", "zyx", "123", "456", "780", "0"};

int32_t main(void) {
	uint32_t i = 0;
	char **paramline = &cmd[i];
	printf("%s\n", paramline[0]);
	return 0;
}

