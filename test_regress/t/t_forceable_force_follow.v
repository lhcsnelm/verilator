// DESCRIPTION: Verilator: Verilog Test module
//
// A force in code of a forceable signal follows its RHS until released
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module sub (
    input logic [7:0] in_i,
    output logic [7:0] out_o
);
  assign out_o = in_i;
endmodule

module t;
  logic [7:0] src = 8'h11;
  logic [7:0] lo = 8'h0a;
  logic [7:0] fv  /*verilator forceable*/;
  logic [7:0] q;
  sub u (
      .in_i(8'h00),
      .out_o(q)
  );

  initial begin
    force fv = src;
    force u.in_i = src;
    #1;
    `checkh(fv, 8'h11);
    `checkh(q, 8'h11);
    src = 8'h22;
    #1;
    `checkh(fv, 8'h22);
    `checkh(q, 8'h22);
    // A later force of part of the range takes those bits, the rest still follows src
    force fv[3:0] = lo[3:0];
    #1;
    `checkh(fv, 8'h2a);
    src = 8'h33;
    lo = 8'h0b;
    #1;
    `checkh(fv, 8'h3b);
    release fv[3:0];
    src = 8'h44;
    #1;
    `checkh(fv[7:4], 4'h4);
    release fv;
    release u.in_i;
    src = 8'h55;
    #1;
    `checkh(fv[7:4], 4'h4);
    `checkh(q, 8'h00);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
