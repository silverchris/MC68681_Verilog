`timescale 1ns / 1ps

module FD (
    input D,
    input C,
    output reg Q
);
  always @(posedge C) Q <= D;
endmodule

