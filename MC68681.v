`timescale 1ns / 1ps
module MC68681 (
    input A0,
    input A1,
    input A2,
    input A3,
    input CLK,
    input RXA,
    input R_W,
    input CS_IN,
    output TXA,
    output _INT,
    inout [7:0] DATA_IN,
    output wire LED1,
    output wire LED2
);

  wire _CS_SYNC;
  wire w_BLOCKA_CS;
  wire w_BLOCKB_CS;
  wire w_CTRLA_CS;
  wire w_CTRLB_CS;

  reg MASTER_ENABLE;


  // wire CLK;

  // SB_HFOSC inthosc (
  //     .CLKHFPU(1'b1),
  //     .CLKHFEN(1'b1),
  //     .CLKHF  (CLK)
  // );

  reg r1_Data;
  reg r2_Data;
  reg CS;

  reg r1_RW;
  reg r2_RW;
  reg RW;

  reg [7:0] d1_in;
  reg [7:0] d2_in;
  reg [7:0] DATA;
  reg [7:0] d1_OUT;
  reg [7:0] d2_OUT;
  reg [7:0] DATA_OUT;
  reg [7:0] int_DATA_OUT;

  assign DATA_IN = (!CS_IN & R_W) ? int_DATA_OUT : 8'bz;

  always @(posedge CLK) begin
    // r1_Data is METASTABLE, r2_Data and r3_Data are STABLE
    r1_Data <= CS_IN;
    r2_Data <= r1_Data;
    CS <= r2_Data;
    r1_RW <= R_W;
    r2_RW <= r1_RW;
    RW <= r2_RW;

    d1_in <= DATA_IN;
    d2_in <= d1_in;
    DATA <= d2_in;
  end

  assign LED1 = !CS;
  assign LED2 = !CS & RW;

  assign w_BLOCKA_CS = !CS & !A3 & !A2;
  assign w_BLOCKB_CS = !CS & A3 & !A2;
  assign w_CTRLA_CS = !CS & !A3 & A2;
  assign w_CTRLB_CS = !CS & A3 & !A2;

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
      .R_W(RW),
      ._CS(w_BLOCKA_CS),
      .RX(RXA),
      .TX(TXA),
      .CLK(CLK),
      .FFULL(FFULLA),
      .TxRDY(TxRDYA),
      .DATA(DATA),
      .DATA_OUT(int_DATA_OUT),
      .MASTER_ENABLE(MASTER_ENABLE)
  );

  CTRLA ctrla (
      .A0(A0),
      .A1(A1),
      .CLK(CLK),
      .R_W(RW),
      .CS(w_CTRLA_CS),
      .FFULLA(FFULLA),
      .FFULLB(0),
      .TxRDYA(TxRDYA),
      .TxRDYB(0),
      ._INT(_INT),
      .DATA(DATA),
      .DATA_OUT(int_DATA_OUT)

  );




endmodule
