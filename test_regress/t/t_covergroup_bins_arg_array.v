// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkr(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got=%f exp=%f\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Array bins without a size whose values are of covergroup arguments (IEEE 1800-2023 19.5)
module t;
  covergroup cg(int num_bins) with function sample(int target, bit flag);
    cp_target: coverpoint target {
      bins low[] = {[0 : num_bins - 1]};
      bins high[] = {num_bins, num_bins + 2};
      bins fixed[] = {[100 : 101]};
    }
    cp_flag: coverpoint flag;
    cx: cross cp_target, cp_flag;
  endgroup

  cg cg3 = new(3);
  cg cg5 = new(5);

  initial begin
    cg3.sample(0, 0);
    cg3.sample(2, 1);
    cg3.sample(3, 0);
    cg3.sample(9, 0);
    cg5.sample(4, 1);
    cg5.sample(101, 1);
    // low[0..2] high[3] high[5] fixed[100] fixed[101]: 3 of 7 hit
    `checkr(cg3.cp_target.get_inst_coverage(), 300.0 / 7);
    // low[0..4] high[5] high[7] fixed[100] fixed[101]: 2 of 9 hit
    `checkr(cg5.cp_target.get_inst_coverage(), 200.0 / 9);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
