// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// The weights of a dist in randomize() with and std::randomize() with (IEEE 1800-2023 18.5.3)

class Item;
  rand bit [1:0] b;
endclass

module t;
  // Of 400 draws weighted 3:1, about 300 are 0
  task automatic check_weighted(string what, int zeros);
    $display("%s zeros=%0d", what, zeros);
    if (zeros < 240 || zeros > 360) $stop;
  endtask

  initial begin
    automatic Item it = new;
    bit [1:0] b;
    bit [31:0] v;
    int ok;
    int inline_zeros;
    int std_zeros;
    int slice_zeros;
    inline_zeros = 0;
    std_zeros = 0;
    slice_zeros = 0;
    repeat (400) begin
      ok = it.randomize() with { b dist {0 :/ 3, 1 :/ 1}; };
      `checkd(ok, 1);
      if (it.b > 1) $stop;
      inline_zeros += it.b == 0;
      ok = std::randomize(b) with { b dist {0 :/ 3, 1 :/ 1}; };
      `checkd(ok, 1);
      if (b > 1) $stop;
      std_zeros += b == 0;
      ok = std::randomize(v) with { v[1:0] dist {0 :/ 3, 1 :/ 1}; };
      `checkd(ok, 1);
      if (v[1:0] > 1) $stop;
      slice_zeros += v[1:0] == 0;
    end
    check_weighted("inline", inline_zeros);
    check_weighted("std", std_zeros);
    check_weighted("slice", slice_zeros);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
