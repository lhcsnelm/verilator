// DESCRIPTION: Verilator: Verilog Test module
//
// Elements added to associative arrays after construction are randomized.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Cls;
  rand int unsigned by_int[int];
  rand int unsigned by_string[string];
  constraint c {
    foreach (by_int[i]) by_int[i] inside {[5 : 100]};
    foreach (by_string[i]) by_string[i] inside {[5 : 100]};
  }
endclass

module t;
  initial begin
    Cls c;
    int ok;
    c = new;
    c.by_int[3] = 0;
    c.by_int[7] = 0;
    c.by_string["a"] = 0;
    c.by_string["longer_key"] = 0;
    ok = c.randomize();
    `checkd(ok, 1);
    foreach (c.by_int[i]) `checkd(c.by_int[i] inside {[5 : 100]}, 1);
    foreach (c.by_string[i]) `checkd(c.by_string[i] inside {[5 : 100]}, 1);
    c.by_int[9] = 0;
    ok = c.randomize();
    `checkd(ok, 1);
    `checkd(c.by_int[9] inside {[5 : 100]}, 1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
