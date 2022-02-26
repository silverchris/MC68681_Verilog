module pulse_gen (
    d,
    clk,
    pulse
);
  input clk;
  input d;
  output reg pulse;
  reg state;

  always @(posedge clk) begin
    state <= d;
    pulse <= state != d && d;
  end
endmodule
