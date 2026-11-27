// DESCRIPTION: Verilator: Verilog Test module
//
// A reduction constrains the elements of an array whose size is solved too.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Cls;
  rand int unsigned lens[];
  rand bit [7:0] bytes[$];
  int n = 3;
  constraint c_lens {
    lens.size() == n;
    lens.sum() == 10;
    foreach (lens[i]) lens[i] inside {[1 : 10]};
  }
  constraint c_bytes {
    bytes.size() == 4;
    bytes.sum() with (int'(item)) == 600;
  }
endclass

module t;
  initial begin
    Cls c;
    int ok;
    int sum;
    c = new;
    repeat (2) begin
      ok = c.randomize();
      `checkd(ok, 1);
      `checkd(c.lens.size(), c.n);
      sum = 0;
      foreach (c.lens[i]) sum += c.lens[i];
      `checkd(sum, 10);
      `checkd(c.bytes.size(), 4);
      sum = 0;
      foreach (c.bytes[i]) sum += int'(c.bytes[i]);
      `checkd(sum, 600);
      // Resized from a size of its own, which the reduction is over first
      c.n = 5;
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
