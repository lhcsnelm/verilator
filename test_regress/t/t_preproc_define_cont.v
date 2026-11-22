// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checks(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// The text of a macro starting on a continuation line has no leading white space, so neither
// has its stringification

`define STRINGIFY(x) `"x`"
`define PATH \
    top.sub.mem
`define PATH_SPACE    \
  \
    top.sub.mem

module t;
  initial begin
    `checks(`STRINGIFY(`PATH), "top.sub.mem");
    `checks(`STRINGIFY(`PATH_SPACE), "top.sub.mem");
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
