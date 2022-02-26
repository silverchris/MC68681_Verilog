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
	{CMD_W, 5, 0x03},
    {CMD_W, 3, 'D'}
};

int main(int argc, char **argv) {
	Verilated::commandArgs(argc, argv);
	TESTBENCH<Vtest> *tb = new TESTBENCH<Vtest>();

	tb->opentrace("test_int.vcd");

	long int count = 0;

    for(int cmd_index = 0; cmd_index < sizeof(cmds)/sizeof(cmds[0]); cmd_index++){
        printf("%d, %d\r\n", cmd_index, sizeof(cmds)/sizeof(cmds[0]));
        if(cmds[cmd_index][0] == 0){
            tb->write(cmds[cmd_index][1], cmds[cmd_index][2]);
        }
        else if(cmds[cmd_index][0] == 1){
            tb->read(cmds[cmd_index][1]);
        }
        for(int ticks = 0; ticks <=320; ticks++){
            tb->tick();
        }
}
    char send = '!';
	while(!tb->done()) {
        if(!tb->m_core->_INT){
            char isr = tb->read(5);
            if(isr & 0x02){
                while(tb->read(1) & 0x01){
                    printf("%c\r\n", tb->read(3));
                }
            }
            else if(isr & 0x01){
              tb->write(3, send);
              send++;
              if(send > 126){
                  send = '!';
              }
            }
        }
		tb->tick();
	} exit(EXIT_SUCCESS);
}