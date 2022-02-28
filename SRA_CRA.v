`timescale 1ns / 1ps
module SRA_CRA (
    input [7:0] data,
    output wire [7:0] data_out,
    input r_w,
    input cra_cs,
    input sra_cs,
    input clk,
    input wire FFULL,
    input wire TxEMT,
    input wire OVERRUN,
    input wire TxRDY,
    input wire RxRDY,
    output reg TxEN,
    output reg RxEN,
    output reg RxReset,
    output reg TxReset,
    output reg MrReset,
    output reg MASTER_ENABLE
);

  reg [7:0] internal_status = 8'b0;
  assign data_out = (sra_cs == 1 && r_w == 1) ? internal_status : 8'bz;

  reg cs_sra_state = 0;

  always @(posedge clk) begin
    internal_status[4] <= OVERRUN;
    internal_status[3] <= TxEMT;
    internal_status[3] <= TxRDY;
    internal_status[2] <= TxRDY;
    internal_status[1] <= FFULL;
    internal_status[0] <= RxRDY;


    if (cra_cs == 1) begin
      if (r_w == 0) begin
        case (data[6:4])
          'b001:  MrReset <= 1;  //Reset MR Pointer
          'b010:  RxReset <= 0;  //Reset Reciever
          'b011:  TxReset <= 0;  //Reset Transmitter
          //3'b100, //Reset Error
          3'b101: MASTER_ENABLE <= 1;  //Reset Channel A Break change interrupt
          //3'b110, //start break
          //3'b111, //stop break
        endcase
        if (data[3] == 1) TxEN <= 1'b0;
        if (data[2] == 1) TxEN <= 1'b1;
        if (data[1] == 1) RxEN <= 1'b0;
        if (data[0] == 1) RxEN <= 1'b1;
        cs_sra_state <= 1;
      end
    end else begin
      MrReset <= 0;  //Reset MR Pointer
      RxReset <= 1;  //Reset Reciever
      TxReset <= 1;  //Reset Transmitter

    end
  end

endmodule

