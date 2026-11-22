// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

typedef struct {
  rand bit [3:0] lo;
  rand bit [3:0] hi;
} inner_t;

typedef struct {
  rand bit cpol;
  rand bit [15:0] div;
  rand inner_t inner;
} cfg_t;

class Cls;
  rand cfg_t cfg;
  rand int n;
  constraint cfg_c {
    cfg.cpol dist {1'b0 :/ 1, 1'b1 :/ 1};
    cfg.div inside {[3 : 9]};
    cfg.inner.lo < cfg.inner.hi;
  }
  constraint n_c {n inside {[0 : 1000]};}
  // Randomizing one member leaves the other rand members as state variables
  function void randomize_n();
    if (this.randomize(n) == 0) `stop;
  endfunction
endclass

module t;
  initial begin
    automatic Cls obj = new;
    cfg_t saved;
    repeat (10) begin
      if (obj.randomize() == 0) `stop;
      if (obj.cfg.div < 3 || obj.cfg.div > 9) `stop;
      if (obj.cfg.inner.lo >= obj.cfg.inner.hi) `stop;
      saved = obj.cfg;
      obj.randomize_n();
      `checkd(obj.cfg.cpol, saved.cpol);
      `checkd(obj.cfg.div, saved.div);
      `checkd(obj.cfg.inner.lo, saved.inner.lo);
      `checkd(obj.cfg.inner.hi, saved.inner.hi);
      if (obj.n < 0 || obj.n > 1000) `stop;
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
