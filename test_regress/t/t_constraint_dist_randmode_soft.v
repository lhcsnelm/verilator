// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// The weights of a dist are only a preference (IEEE 1800-2023 18.5.3), so a value the
// weighted selection prefers but other constraints exclude leaves randomize() succeeding, also
// for variables with rand_mode

class Cls;
  rand bit [8:0] a;
  rand bit [7:0] b;
  bit [8:0] m = 267;
  // With an empty range
  constraint a_c {a dist {[0 : m] :/ m, [m + 1 : 255] :/ 1};}
  constraint b_c {
    b dist {1 :/ 1, 2 :/ 1};
    b != 1;
  }
endclass

module t;
  initial begin
    automatic Cls c = new;
    automatic int fails = 0;
    c.a.rand_mode(1);
    repeat (500) begin
      if (c.randomize() == 0) ++fails;
      `checkd(c.b, 2);
    end
    `checkd(fails, 0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
