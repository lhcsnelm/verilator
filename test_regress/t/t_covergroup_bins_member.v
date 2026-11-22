// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Bins with values of members of the class enclosing the covergroup, or of its constructor
// arguments, taken when the covergroup is constructed

class Cov;
  localparam int W = 4;
  const bit [W-1:0] max_val = 2 ** W - 1;
  int skip;

  covergroup cg with function sample (bit [W-1:0] v);
    cp: coverpoint v {
      bins zero = {0};
      bins middle = {[1 : (max_val - 1)]};
      bins top = {max_val};
      ignore_bins ign = {skip};
    }
  endgroup

  function new(int skip);
    this.skip = skip;
    cg = new;
  endfunction
endclass

covergroup cg_args (bit [3:0] size) with function sample (bit [3:0] v);
  cp: coverpoint v {
    bins empty = {0};
    bins partial = {[1 : size - 1]};
    bins full = {size};
  }
endgroup

module t;
  cg_args c4 = new(4);
  cg_args c8 = new(8);

  initial begin
    automatic Cov c = new(5);
    c4.sample(0);
    c4.sample(4);
    `checkd($rtoi(c4.get_inst_coverage()), 66);
    c4.sample(3);
    `checkd($rtoi(c4.get_inst_coverage()), 100);
    c8.sample(4);
    `checkd($rtoi(c8.get_inst_coverage()), 33);
    c.cg.sample(0);
    c.cg.sample(15);
    `checkd($rtoi(c.cg.get_inst_coverage()), 66);
    // Ignored, so not in the middle bin
    c.cg.sample(5);
    `checkd($rtoi(c.cg.get_inst_coverage()), 66);
    c.cg.sample(7);
    `checkd($rtoi(c.cg.get_inst_coverage()), 100);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
