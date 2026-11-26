// DESCRIPTION: Verilator: Verilog Test module
//
// std::randomize() with, in a class extending a parameterized base, binds the with-clause
// names in the caller's scope, not as members of a randomize target.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

class Cfg;
  int unsigned min_data = 2;
  int unsigned max_data = 5;
endclass

class Base #(type CFG_T = Cfg);
  CFG_T cfg = new;
endclass

class Seq extends Base #(Cfg);
  function int unsigned pick();
    int unsigned n;
    if (std::randomize(n) with {n inside {[cfg.min_data : cfg.max_data]};} != 1) $stop;
    return n;
  endfunction
endclass

module t;
  initial begin
    automatic Seq s = new;
    repeat (20) begin
      automatic int unsigned n = s.pick();
      if (n < 2 || n > 5) $stop;
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
