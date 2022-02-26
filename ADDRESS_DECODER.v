`timescale 1ns / 1ps

module ADDRESS_DECODER (
    A0,
    A1,
    A2,
    E,
    D0,
    D1,
    D2,
    D3,
    D4,
    D5,
    D6,
    D7
);

  input A0;
  input A1;
  input A2;
  input E;
  output D0;
  output D1;
  output D2;
  output D3;
  output D4;
  output D5;
  output D6;
  output D7;


  and I_36_30 (D7, A2, A1, A0, E);
  and I_36_31 (D6, ~A0, A2, A1, E);
  and I_36_32 (D5, ~A1, A2, A0, E);
  and I_36_33 (D4, ~A1, ~A0, A2, E);
  and I_36_34 (D3, ~A2, A0, A1, E);
  and I_36_35 (D2, ~A2, ~A0, A1, E);
  and I_36_36 (D1, ~A2, ~A1, A0, E);
  and I_36_37 (D0, ~A2, ~A1, ~A0, E);
endmodule
