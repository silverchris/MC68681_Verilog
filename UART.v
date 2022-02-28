`timescale 1ns / 1ps
module UART (
    input cs,
    input rw,
    input [7:0] data,
    output [7:0] data_out,
    input clk,
    output wire TX,
    output wire TxRDY,

    input RX,
    input TxEN,
    input RxEN,
    input TxReset,
    input RxReset,
    input LocalLoop,
    input RemoteLoop,
    input AutoEcho,

    output wire OVER,
    output wire FFULL,
    output wire RxRDY
);



  wire internal_tx;
  wire internal_rx;
  wire internal_DV;
  wire DV;
  wire [7:0] internal_d_in;
  wire [7:0] internal_d_out;
  wire [7:0] fifo_out;

  assign data_out = (cs == 1 && rw == 1) ? fifo_out : 8'bz;


  assign TX = LocalLoop || internal_tx;
  assign internal_rx = !LocalLoop ? RX : internal_tx;

  //  assign internal_d_in = !RemoteLoop ? data : internal_d_out;
  //  assign DV = !RemoteLoop ? (cs & !rw & TxEN) : internal_DV;
  assign DV = (cs & !rw & TxEN);
  assign internal_d_in = data;


  //  wire TxCLK = TxEN & wclk2;
  //  wire RxCLK = RxEN & wclk2;
  wire local_RxReset = RxEN | !RxReset;

  wire wTxDone;
  wire wTxActive;

  //  assign fifo_out = internal_d_out; //bypass fifo

  // sr_latch l_FFULL (
  //     internal_DV,
  //     rw,
  //     FFULL
  // );
  SR_LATCH l_TxRDY (
      wTxDone,
      wTxActive,
      TxRDY
  );

  //  assign FFULL = !RemoteLoop ? internal_DV: 0; //bypass fifo

  FIFO fifo1 (
      .clk(clk),
      .rd(rw & cs),
      .wr(!RemoteLoop ? internal_DV : 0),
      .d_in(internal_d_out),
      .d_out(fifo_out),
      .FFULL(FFULL),
      .OVER(OVER),
      .RxRDY(RxRDY)
  );



  UART_TX tx1 (
      .i_Rst_L(TxReset),
      .i_Clock(clk),
      .o_TX_Serial(internal_tx),
      .i_TX_Byte(internal_d_in),
      .i_TX_DV(DV),
      .o_TX_Done(wTxDone),
      .o_TX_Active(wTxActive)
  );
  UART_RX rx1 (
      .i_Rst_L(local_RxReset),
      .i_Clock(clk),
      .i_RX_Serial(internal_rx),
      .o_RX_Byte(internal_d_out),
      .o_RX_DV(internal_DV)
  );

endmodule
