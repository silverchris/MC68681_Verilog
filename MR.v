`timescale 1ns / 1ps
module MR (
    input cs,
    input clk,
    input rw,
    input [7:0] data,
    output [7:0] data_out,
    input MrReset,

    output reg  LocalLoop,
    output wire RemoteLoop,
    output wire AutoEcho,
    output wire RxRTSC,
    output wire RxINTS,
    output wire TxRTSC,
    output wire CTSEN
);

  reg [7:0] MR1 = 'h00;
  reg [7:0] MR2 = 'h00;
  reg state = 0;
  wire [7:0] d_in;

  assign LocalLoop = MR2[7] & !MR2[6];
  assign RemoteLoop = MR2[7] & MR2[6];
  assign AutoEcho = !MR2[7] & MR2[6];
  assign TxRTSC = MR2[5];
  assign CTSEN = MR2[4];

  assign RxRTSC = MR1[7];
  assign RxINTS = MR1[6];

  assign data_out = (cs == 1 && rw == 1) ? (state == 0 ? MR1 : MR2) : 8'bz;

  assign d_in = data;

  reg in_cs;


  always @(posedge clk or posedge MrReset) begin
    if (MrReset == 1) state <= 0;
    else begin
      if (rw == 0 && cs == 1) begin
        in_cs <= 1;
        if (state == 0) begin
          MR1 <= d_in;
        end else MR2 <= d_in;
      end else begin
        if (in_cs == 1) begin
          state <= 1;
          in_cs <= 0;
        end
      end
    end
  end
endmodule
