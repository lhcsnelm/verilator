// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module t;

  bit [3:0] a;
  bit [3:0] b;

  initial begin
    // Not constants, so not folded
    a = 4'h5 ^ 4'($urandom_range(0, 0));
    b = 4'h5 ^ 4'($urandom_range(0, 0));
    `checkh(a ==? b, 1'b1);
    `checkh(a !=? b, 1'b0);
    b = 4'h6 ^ 4'($urandom_range(0, 0));
    `checkh(a ==? b, 1'b0);
    `checkh(a !=? b, 1'b1);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
