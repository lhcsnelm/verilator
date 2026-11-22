// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A parameter whose type depends on another parameter, in an instance with other values than
// an instance under an earlier top using the defaults

module flop #(
    parameter int Width = 1,
    parameter logic [Width-1:0] ResetValue = 0
) (
    input clk,
    input rst_n,
    input [Width-1:0] d,
    output logic [Width-1:0] q
);
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n) q <= ResetValue;
    else q <= d;
endmodule

module a_unused;
  logic clk, rst_n, q;
  flop u_bit (.clk, .rst_n, .d(q), .q(q));
endmodule

module t;
  logic clk = 0;
  logic rst_n = 0;
  always #5 clk = ~clk;
  logic [2:0] q;
  flop #(.Width(3), .ResetValue(3'b101)) u_three (.clk, .rst_n, .d(q), .q(q));
  initial begin
    @(posedge clk);
    #1;
    `checkh(q, 3'b101);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
