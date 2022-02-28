`timescale 1ns / 1ps
module CTRLA (
    input A0,
    input A1,
    input CLK,
    input R_W,
    input CS,
    input FFULLA,
    input FFULLB,
    input TxRDYA,
    input TxRDYB,
    output _INT,
    input [7:0] DATA,
    output [7:0] DATA_OUT
);
  wire w_ISR_CS;
  assign w_ISR_CS = CS & ~A1 & A0;



  ISR_IMR isr_imr (
      .clk(CLK),
      .cs(w_ISR_CS),
      .rw(R_W),
      .FFULLA(FFULLA),
      .TxRDYA(TxRDYA),
      .FFULLB(FFULLB),
      .TxRDYB(TxRDYB),
      .INT(_INT),
      .data(DATA[7:0]),
      .data_out(DATA_OUT)
  );

endmodule
