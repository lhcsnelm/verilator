// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkr(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got=%f exp=%f\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Enumeration values with x or z are not coverpoint values, so get no automatic bin
// (IEEE 1800-2023 19.5.7)
module t;
  typedef enum logic [1:0] {
    OK = 2'd0,
    ERR = 2'd1,
    UNDRIVEN = 'z
  } sts_e;

  covergroup cg with function sample(sts_e sts);
    cp_sts: coverpoint sts {ignore_bins undriven = {UNDRIVEN};}
    cp_all: coverpoint sts;
  endgroup

  cg c = new;

  initial begin
    c.sample(OK);
    `checkr(c.cp_sts.get_inst_coverage(), 50.0);
    `checkr(c.cp_all.get_inst_coverage(), 50.0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
