`timescale 1ns / 1ps
module ISR_IMR (
    input clk,
    input cs,
    input rw,
    inout [7:0] data,
    input FFULLA,
    input TxRDYA,
    input FFULLB,
    input TxRDYB,
    output reg INT = 1
);
  reg [7:0] IMR = 'b10;
  reg [7:0] ISR = 'b00;
  reg [7:0] state;

  assign data = (cs == 1 && rw == 1) ? ISR : 8'bz;

  always @(posedge clk) begin
    state  <= ISR;
    ISR[0] <= TxRDYA == 1;
    ISR[1] <= FFULLA == 1;

    if (rw == 0 && cs == 1) begin
      IMR <= data;
    end

    if (ISR != state)
      if ((IMR & ISR) != 0) INT <= 0;
      else INT <= 1;
  end

endmodule
