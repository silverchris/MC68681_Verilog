`timescale 1ns / 1ps
module MR (
    cs,
    rw,
    data,
    MrReset,
    LocalLoop,
    RemoteLoop,
    AutoEcho,
    RxRTSC,
    RxINTS,
    TxRTSC,
    CTSEN
);
  input cs;
  input rw;
  inout [7:0] data;
  input MrReset;

  output reg LocalLoop;
  output wire RemoteLoop;
  output wire AutoEcho;
  output wire RxRTSC;
  output wire RxINTS;
  output wire TxRTSC;
  output wire CTSEN;

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

  assign data = (cs == 1 && rw == 1) ? (state == 0 ? MR1 : MR2) : 8'bz;

  assign d_in = data;


  always @(posedge cs or posedge MrReset) begin
    if (MrReset == 1) state <= 0;
    else begin
      if (rw == 0) begin
        if (state == 0) begin
          MR1 <= d_in;
        end else MR2 <= d_in;
      end
      state <= 1;
    end
  end
endmodule
