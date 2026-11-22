// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t;

  bind u_a.gen_loop[0].u_b mycheck u_check ();

  moda u_a ();

endmodule

module moda;
  for (genvar i = 0; i < 2; ++i) begin : gen_loop
    modb u_b ();
  end
endmodule

module modb;
endmodule

module mycheck;
endmodule
