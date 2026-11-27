// DESCRIPTION: Verilator: Verilog Test module
//
// A dist on a state value, as a non-rand member of a rand object, only tests it.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on


class Mixed;
  rand int unsigned d;
  int unsigned nf;
endclass

class Holder;
  rand Mixed m;
  constraint c {
    m.nf dist {
      5 := 9,
      70 := 1
    };
  }
  function new();
    m = new;
  endfunction
endclass

module t;
  initial begin
    Holder h;
    int ok;
    h = new;
    h.m.nf = 5;
    repeat (10) begin
      ok = h.randomize();
      `checkd(ok, 1);
      `checkd(h.m.nf, 5);
    end
    h.m.nf = 7;
    ok = h.randomize();
    `checkd(ok, 0);
    `checkd(h.m.nf, 7);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
