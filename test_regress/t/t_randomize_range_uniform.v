// DESCRIPTION: Verilator: Verilog Test module
//
// Values of a variable constrained to a range are drawn about uniformly, also by objects
// randomized once each, which are not sampled through cells of their solution space.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on


class Item;
  rand int unsigned len;
  rand int unsigned delay;
  rand bit [31:0] addr;
  rand bit [1:0] size;
  constraint c {
    len inside {[1 : 10]};
    delay inside {[0 : 50]};
    size <= 2;
    (addr & ((32'd1 << size) - 1)) == 0;
  }
endclass

module t;
  localparam int N = 2000;
  initial begin
    Item item;
    int ok;
    int lens[11];
    int delays[51];
    repeat (N) begin
      item = new;
      ok = item.randomize();
      `checkd(ok, 1);
      ++lens[item.len];
      ++delays[item.delay];
    end
    // Expected 200 and about 39 each
    for (int v = 1; v <= 10; ++v) `checkd(lens[v] inside {[120 : 280]}, 1);
    foreach (delays[v]) `checkd(delays[v] inside {[15 : 70]}, 1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
