// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

typedef enum logic [1:0] {
  OpIdle = 0,
  OpWip = 1,
  OpDoneSuccess = 2,
  OpDoneFail = 3
} status_e;

module t;

  status_e cur;
  logic [3:0] lvar;
  logic [1:0] data;
  localparam logic [1:0] WILD = 2'b1x;

  initial begin
    cur = OpWip;
    lvar = 4'b0110;
    // Four-state variables as members
    data = 2'd1 ^ 2'($urandom_range(0, 0));
    `checkh(data inside {cur, OpDoneSuccess}, 1'b1);
    data = 2'd3 ^ 2'($urandom_range(0, 0));
    `checkh(data inside {cur, OpDoneSuccess}, 1'b0);
    `checkh(4'b0110 inside {lvar}, 1'b1);
    `checkh(4'b0111 inside {lvar, lvar + 4'd2}, 1'b0);
    `checkh(4'b1000 inside {lvar, lvar + 4'd2}, 1'b1);
    // Wildcard bits of a parameter still match
    `checkh(data inside {WILD}, 1'b1);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
