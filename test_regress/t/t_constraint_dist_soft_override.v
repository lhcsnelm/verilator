// DESCRIPTION: Verilator: Verilog Test module
//
// A soft dist is a default, which an inline constraint overrides.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Item;
  rand int unsigned delay;
  rand int unsigned stable;
  constraint delay_c {
    soft delay dist {0 :/ 5, [1 : 10] :/ 5};
    soft stable dist {1 :/ 5, [2 : 10] :/ 5};
  }
endclass

module t;
  initial begin
    Item item;
    int ok;
    item = new;
    repeat (10) begin
      ok = item.randomize() with {delay inside {[10000 : 20000]};};
      `checkd(ok, 1);
      `checkd(item.delay inside {[10000 : 20000]}, 1);
      `checkd(item.stable inside {[1 : 10]}, 1);
      ok = item.randomize();
      `checkd(ok, 1);
      `checkd(item.delay inside {[0 : 10]}, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
