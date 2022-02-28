`timescale 1ns / 1ps

module test (
    input A0,
    input A1,
    input A2,
    input A3,
    input CLK,
    input RX,
    input R_W,
    input CS,
    output TX,
    output _INT,
    input [7:0] DATA_IN,
    output [7:0] DATA_OUT,
    output wire LED1,
    output wire LED2
);
  wire [7:0] DATA;
  assign DATA_OUT = (R_W == 1 && CS == 0) ? DATA : 8'bz;
  assign DATA = DATA_IN;

  // Instantiate the UUT
  MC68681 UUT (
      .A0(A0),
      .A1(A1),
      .A2(A2),
      .A3(A3),
      .CLK(CLK),
      .R_W(R_W),
      .CS_IN(CS),
      .RXA(RX),
      .TXA(TX),
      .DATA_IN(DATA),
      ._INT(_INT),
      .LED1(LED1),
      .LED2(LED2)
  );
endmodule
