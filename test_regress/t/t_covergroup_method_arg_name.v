// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkr(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got=%f exp=%f\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Formal arguments of a covergroup may have the names of its methods start and stop

module t;
  covergroup cg_sample with function sample (bit start, bit stop);
    cp_start : coverpoint start;
    cp_stop : coverpoint stop;
  endgroup

  covergroup cg_new (bit start) with function sample (bit [1:0] value);
    cp : coverpoint value iff (start);
  endgroup

  cg_sample c1 = new;
  cg_new c2 = new(1);
  cg_new c3 = new(0);

  initial begin
    c1.stop();
    c1.start();
    c1.sample(1, 0);
    `checkr(c1.get_inst_coverage(), 50.0);
    c1.sample(0, 1);
    `checkr(c1.get_inst_coverage(), 100.0);
    c2.stop();
    c2.start();
    c2.sample(1);
    c3.sample(1);
    `checkr(c2.get_inst_coverage(), 25.0);
    `checkr(c3.get_inst_coverage(), 0.0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
