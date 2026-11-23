// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// The weights of a dist under an if/else or implication constraint are only a preference
// (IEEE 1800-2023 18.5.3), which other constraints may override

class Item;
  rand bit rcont, read, stop, start;
  rand bit [3:0] n;
  constraint rcont_c {
    if (read) {
      rcont == ~stop;
    } else {
      rcont dist {1 :/ 1, 0 :/ 2};
    }
  }
  constraint n_c {start -> n dist {[0 : 3] :/ 1, [12 : 15] :/ 9};}
endclass

module t;
  initial begin
    automatic Item it = new;
    int ok;
    int ones;
    int high;
    ones = 0;
    high = 0;
    repeat (100) begin
      ok = it.randomize() with {
        start == 1;
        read == 0;
        rcont == 0;
        n == 1;
      };
      `checkd(ok, 1);
      `checkd(it.rcont, 0);
      `checkd(it.n, 1);
    end
    repeat (300) begin
      ok = it.randomize() with {
        read == 0;
        start == 1;
      };
      `checkd(ok, 1);
      ones += it.rcont;
      high += it.n >= 12;
    end
    // Still weighted, as of 100 and 270 expected
    if (ones < 50 || ones > 150) $stop;
    if (high < 220) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
