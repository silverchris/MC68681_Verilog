`timescale 1ns / 1ps
module MC68681 (
    input A0,
    input A1,
    input A2,
    input A3,
    input CLK,
    input RXA,
    input R_W,
    input _CS,
    output TXA,
    output _INT,
    inout [7:0] DATA
);

  wire _CS_SYNC;
  wire w_BLOCKA_CS;
  wire w_BLOCKB_CS;
  wire w_CTRLA_CS;
  wire w_CTRLB_CS;

  assign w_BLOCKA_CS = !_CS & !A3 & !A2;
  assign w_BLOCKB_CS = !_CS & A3 & !A2;
  assign w_CTRLA_CS  = !_CS & !A3 & A2;
  assign w_CTRLB_CS  = !_CS & A3 & !A2;

//   FD CS_SYNC (
//       _CS,
//       CLK,
//       _CS_SYNC
//   );

  wire FFULLA;
  wire TxRDYA;
  BLOCK BLOCKA (
      .A0(A0),
      .A1(A1),
      .R_W(R_W),
      ._CS(w_BLOCKA_CS),
      .RX(RXA),
      .TX(TXA),
      .CLK(CLK),
      .FFULL(FFULLA),
      .TxRDY(TxRDYA),
      .DATA(DATA)
  );

  CTRLA ctrla (
      .A0(A0),
      .A1(A1),
      .CLK(CLK),
      .R_W(R_W),
      .CS(w_CTRLA_CS),
      .FFULLA(FFULLA),
      .FFULLB(0),
      .TxRDYA(TxRDYA),
      .TxRDYB(0),
      ._INT(_INT),
      .DATA(DATA)
  );




endmodule
