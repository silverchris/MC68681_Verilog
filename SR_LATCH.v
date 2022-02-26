`timescale 1ns / 1ps
module SR_LATCH (
    input  wire S,
    R,
    output wire Q
);
  wire Q_not;

  assign Q     = ~(R | Q_not);
  assign Q_not = ~(S | Q);
endmodule
