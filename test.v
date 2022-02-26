`timescale 1ns / 1ps

module test (
    input A0,
    input A1,
    input A2,
    input A3,
    input CLK,
    input RX,
    input R_W,
    input _CS,
    output TX,
    output _INT,
    input [7:0] DATA_IN,
	output [7:0] DATA_OUT
);
  wire [7:0] DATA;
  assign DATA_OUT = (R_W == 1 && _CS==0) ? DATA : 8'bz;
  assign DATA = DATA_IN;

  // Instantiate the UUT
  MC68681 UUT (
      .A0  (A0),
      .A1  (A1),
      .A2  (A2),
      .A3  (A3),
      .R_W (R_W),
      ._CS (_CS),
      .RXA  (RX),
      .TXA  (TX),
      .CLK (CLK),
      .DATA(DATA),
	  ._INT(_INT)
  );
endmodule
