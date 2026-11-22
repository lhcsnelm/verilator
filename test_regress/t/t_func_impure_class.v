// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

package pkg;
  int calls;
  // Not inlined, and impure, but called only by class methods, which are not inlined either
  function automatic void fill(string name, ref int q[]);
    // verilator no_inline_task
    q = new[name.len()];
    ++calls;
  endfunction
endpackage

class Scoreboard;
  int vecs[string][];
  function void load(string names[]);
    foreach (names[i]) pkg::fill(names[i], vecs[names[i]]);
  endfunction
endclass

module t;
  initial begin
    automatic Scoreboard sb = new;
    sb.load('{"abc", "de"});
    `checkd(sb.vecs["abc"].size(), 3);
    `checkd(sb.vecs["de"].size(), 2);
    `checkd(pkg::calls, 2);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
