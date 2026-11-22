// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t;

  bind u_a.u_none mycheck u_check1 ();  // BAD: no such instance
  bind u_none.u_b mycheck u_check2 ();  // BAD: no such instance
  bind u_a.gen_blk mycheck u_check3 ();  // BAD: not an instance
  bind u_a.u_b : u_a.u_b mycheck u_check4 ();  // BAD: scope is not a module name
  bind moda : u_a.u_b mycheck u_check5 ();  // BAD: not an instance of moda

  moda u_a ();

endmodule

module moda;
  if (1) begin : gen_blk
  end
  modb u_b ();
endmodule

module modb;
endmodule

module mycheck;
endmodule
