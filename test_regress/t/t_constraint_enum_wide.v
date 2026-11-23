// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Constrained random variables of enumeration types wider than 32 bits take their values

class Cls;
  typedef enum logic [39:0] {M0 = 40'h12_3456_789a, M1 = 40'hff_0000_0001} mid_e;
  typedef enum logic [79:0] {
    W0 = {16'h1111, 64'h0},
    W1 = {16'h2222, 64'h5},
    W2 = {16'h3333, 64'h9}
  } wide_e;
  rand mid_e m;
  rand wide_e w;
  constraint c {
    m != M1;
    w != W0;
  }
endclass

module t;
  initial begin
    automatic Cls c = new;
    int ok;
    repeat (20) begin
      ok = c.randomize();
      `checkd(ok, 1);
      `checkd(c.m, Cls::M0);
      `checkd(c.w inside {Cls::W1, Cls::W2}, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
