# Example iCEBreaker Makefile
# Learn more at https://projectf.io/posts/building-ice40-fpga-toolchain/

# configuration
SHELL = /bin/sh
FPGA_PKG = sg48
FPGA_TYPE = up5k
PCF = ICE40UP5K-B-ENV.pcf

# included modules
ADD_SRC = BLOCK.v CTRLA.v UART_RX.v UART_TX.v FIFO.v SR_LATCH.v UART.v SRA_CRA.v MR.v ISR_IMR.v

MC68681: MC68681.rpt MC68681.bin

%.json: %.v $(ADD_SRC)
	yosys -ql $(basename $@)-yosys.log -p 'synth_ice40 -top $(basename $@) -json $@' $< $(ADD_SRC)

%.asc: %.json
	nextpnr-ice40 --ignore-loops --seed 18 --${FPGA_TYPE} --package ${FPGA_PKG} --pcf ${PCF} --pcf-allow-unconstrained --json $< --asc $@

%.rpt: %.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

%.bin: %.asc
	icepack $< MC68681.bin

all: MC68681

clean:
	rm -f top*.json top*.asc top*.rpt *.bin top*yosys.log

.PHONY: all clean

# svg:
# 	yosys \
# 		-p "read_verilog -sv -formal *.v" \
# 		-p "hierarchy -check -top MC68681" \
# 		-p "proc" \
# 		-p "write_json MC68681.json"
# 	netlistsvg -o MC68681.svg MC68681.json

svg:
	yosys -p "prep -top MC68681 ; write_json MC68681.json" *.v
	netlistsvg -o MC68681.svg MC68681.json