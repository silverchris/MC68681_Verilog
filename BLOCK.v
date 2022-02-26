`timescale 1ns / 1ps

module BLOCK (
    input A0,
    input A1,
    input CLK,
    input RX,
    input R_W,
    input _CS,
    output TX,
    output FFULL,
    output TxRDY,
    inout [7:0] DATA
);

  wire MR_CS;
  wire UART_CS;
  wire w_MrReset;
  wire w_LocalLoop;
  wire w_TxReset;
  wire w_RxReset;
  wire w_TxEN;
  wire w_RxEN;
  wire w_SRA_CS;
  wire w_CRA_CS;
  wire w_OVERRUN;
  wire w_RxRDY;

  assign UART_CS = _CS & A0 & A1;
  assign w_CRA_CS = _CS & A1 & !A0;
  assign w_SRA_CS = _CS & !A1 & A0;
  assign MR_CS = _CS & !A1 & !A0;

  SRA_CRA sra_cra (
      .clk(CLK),
      .cra_cs(w_CRA_CS),
      .FFULL(FFULL),
      .OVERRUN(w_OVERRUN),
      .r_w(R_W),
      .sra_cs(w_SRA_CS),
      .TxEMT(0),
      .TxRDY(TxRDY),
      .MrReset(w_MrReset),
      .RxEN(w_RxEN),
      .RxReset(w_RxReset),
      .TxEN(w_TxEN),
      .TxReset(w_TxReset),
      .data(DATA[7:0]),
      .RxRDY(w_RxRDY)
  );
  UART uart (
      .AutoEcho(),
      .clk(CLK),
      .cs(UART_CS),
      .LocalLoop(w_LocalLoop),
      .RemoteLoop(0),
      .rw(R_W),
      .RX(RX),
      .RxEN(w_RxEN),
      .RxReset(w_RxReset),
      .TxEN(w_TxEN),
      .TxReset(w_TxReset),
      .FFULL(FFULL),
      .OVER(w_OVERRUN),
      .TX(TX),
      .TxRDY(TxRDY),
      .data(DATA[7:0]),
      .RxRDY(w_RxRDY)

  );
  MR mr (
      .cs(MR_CS),
      .MrReset(w_MrReset),
      .rw(R_W),
      .AutoEcho(),
      .CTSEN(),
      .LocalLoop(w_LocalLoop),
      .RemoteLoop(),
      .RxINTS(),
      .RxRTSC(),
      .TxRTSC(),
      .data(DATA[7:0])
  );

endmodule
