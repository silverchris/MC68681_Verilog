`timescale 1ns / 1ps
module FIFO (
    clk,
    rd,
    wr,
    d_in,
    d_out,
    FFULL,
    OVER,
    RxRDY
);
  input clk;
  input rd;
  input wr;
  input wire [7:0] d_in;
  output reg [7:0] d_out = 8'b0;
  reg [7:0] mem[3:0];
  reg [1:0] wPTR;
  reg [1:0] rPTR;
  reg [1:0] fCount;

  output wire FFULL;
  output reg OVER;
  output wire RxRDY;

  assign FFULL = (fCount >= 3);
  assign RxRDY = (fCount > 0);

  initial begin
    wPTR   = 0;
    rPTR   = 0;
    fCount = 0;
    OVER   = 0;
  end

  reg cs_state;

  always @(posedge clk) begin
    if (cs_state == 0 & rd == 1) begin
      if (fCount > 0) fCount <= fCount - 1;
      d_out <= mem[rPTR];
      if (rPTR > (3 - 1)) rPTR <= 0;
      else rPTR <= rPTR + 1;
    end else if (wr) begin
      if (FFULL == 1) OVER <= 1;
      else fCount <= fCount + 1;
      mem[wPTR] <= d_in;
      wPTR <= wPTR + 1;
    end
    if (rd == 1) cs_state <= 1;
    else cs_state <= 0;
  end

endmodule
