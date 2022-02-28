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
    input [7:0] DATA,
    output [7:0] DATA_OUT,
    output wire MASTER_ENABLE
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
      .data_out(DATA_OUT),
      .RxRDY(w_RxRDY),
      .MASTER_ENABLE(MASTER_ENABLE)
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
      .data(DATA),
      .data_out(DATA_OUT),
      .RxRDY(w_RxRDY)

  );
  MR mr (
      .cs(MR_CS),
      .clk(CLK),
      .MrReset(w_MrReset),
      .rw(R_W),
      .AutoEcho(),
      .CTSEN(),
      .LocalLoop(w_LocalLoop),
      .RemoteLoop(),
      .RxINTS(),
      .RxRTSC(),
      .TxRTSC(),
      .data(DATA[7:0]),
      .data_out(DATA_OUT)
  );

endmodule
