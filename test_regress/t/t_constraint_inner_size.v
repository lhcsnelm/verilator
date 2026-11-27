// DESCRIPTION: Verilator: Verilog Test module
//
// Constraints on the sizes of the elements of a dynamic array or queue.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Cls;
  rand int unsigned dyn[][];
  rand bit [7:0] q[$][];
  constraint dyn_c {
    dyn.size() inside {[2 : 4]};
    foreach (dyn[i]) dyn[i].size() inside {[1 : 5]};
    foreach (dyn[i, j]) dyn[i][j] < dyn[i].size();
  }
  constraint q_c {
    q.size() == 3;
    foreach (q[i]) q[i].size() == i + 1;
    foreach (q[i, j]) q[i][j] == 8'(i * 10 + j);
  }
endclass

class Derived extends Cls;
  constraint derived_c {foreach (dyn[i]) dyn[i].size() == 2;}
endclass

module t;
  initial begin
    Cls c;
    Derived d;
    int ok;
    c = new;
    d = new;
    repeat (10) begin
      ok = c.randomize();
      `checkd(ok, 1);
      `checkd(c.dyn.size() inside {[2 : 4]}, 1);
      foreach (c.dyn[i]) `checkd(c.dyn[i].size() inside {[1 : 5]}, 1);
      foreach (c.dyn[i, j]) `checkd(c.dyn[i][j] < c.dyn[i].size(), 1);
      `checkd(c.q.size(), 3);
      foreach (c.q[i]) `checkd(c.q[i].size(), i + 1);
      foreach (c.q[i, j]) `checkd(c.q[i][j], 8'(i * 10 + j));
      ok = d.randomize();
      `checkd(ok, 1);
      foreach (d.dyn[i]) `checkd(d.dyn[i].size(), 2);
      foreach (d.dyn[i, j]) `checkd(d.dyn[i][j] < 2, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
