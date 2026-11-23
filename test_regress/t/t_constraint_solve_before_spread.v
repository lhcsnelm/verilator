// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Variables ordered by solve...before are as evenly spread as others, so their unconstrained
// bits are each about as often 0 as 1

class Item;
  rand bit [31:0] base;
  rand bit [63:0] src;
  rand bit [63:0] dst;
  rand bit [3:0] asid;
  constraint c {
    solve base before src;
    solve src before dst;
    asid != 9 -> src[63:32] == '0;
    src[1:0] == 0;
    src != {32'h0, base};
  }
endclass

module t;
  initial begin
    automatic Item it = new;
    int ok;
    int ones;
    ones = 0;
    repeat (200) begin
      ok = it.randomize();
      `checkd(ok, 1);
      `checkd(it.src[1:0], 0);
      ones += $countones(it.src[31:2]);
    end
    // Of the 30 free bits, 15 on average
    $display("ones per value %0d/200", ones);
    if (ones < 14 * 200 || ones > 16 * 200) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
