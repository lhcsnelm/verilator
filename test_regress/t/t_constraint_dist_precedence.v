// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A dist applies to the whole expression before it (IEEE 1800-2023 18.5.3 expression_or_dist)

class Item;
  rand bit [7:0] v;
  rand bit en;
  bit [7:0] m;
  constraint c {
    v <= m;
    v == m dist {0 :/ 1, 1 :/ 1};
    en -> v + 1 > m dist {0 :/ 1, 1 :/ 1};
  }
endclass

module t;
  initial begin
    automatic Item it = new;
    bit [7:0] v;
    bit [7:0] m;
    int ok;
    it.m = 0;
    repeat (20) begin
      ok = it.randomize();
      `checkd(ok, 1);
      `checkd(it.v, 0);
    end
    m = 0;
    repeat (20) begin
      ok = std::randomize(v) with {
        v <= m;
        v == m dist {0 :/ 3, 1 :/ 1};
      };
      `checkd(ok, 1);
      `checkd(v, 0);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
