#include <stdio.h>
#include "Vtest.h"
#include "verilated.h"

#include "testbench.hpp"

#define CMD_W 0
#define CMD_R 1
#define CMD_NOP 2

uint8_t cmds[][3] = {
	{CMD_W, 0, 0x93},
	{CMD_W, 0, 0x80},
	{CMD_W, 2, 0x05},
	{CMD_W, 3, 'D'},
	{CMD_NOP, 0, 0},
	{CMD_R, 3, 0},
	{CMD_W, 0, 0x00},
	{CMD_W, 3, 'A'}
};

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	TESTBENCH<Vtest> *tb = new TESTBENCH<Vtest>();

	tb->opentrace("trace.vcd");

	long int count = 0;
	int cmd_index = 0;

	while(!tb->done()) {
		tb->tick();
		if(count >= 320){
			printf("%d, %d\r\n", cmd_index, sizeof(cmds)/sizeof(cmds[0]));
			if(cmd_index >= sizeof(cmds)/sizeof(cmds[0])) break;
			if(cmds[cmd_index][0] == 0){
				tb->write(cmds[cmd_index][1], cmds[cmd_index][2]);
			}
			else if(cmds[cmd_index][0] == 1){
				tb->read(cmds[cmd_index][1]);
			}
			count = 0;
			cmd_index += 1;
		}
		count += 1;
	} exit(EXIT_SUCCESS);
}