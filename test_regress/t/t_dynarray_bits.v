// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2020 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module t;

  typedef struct packed {
    logic [3:0] a;
    logic [7:0] b;
  } pair_t;

  integer a[];
  bit [7:0] q[$];
  pair_t s[];
  int u[][3];

  initial begin
    `checkd($bits(a), 0);
    a = new[10];
    `checkd($bits(a), 10 * 32);
    `checkd($bits(q), 0);
    q.push_back(8'h1);
    q.push_back(8'h2);
    `checkd($bits(q), 16);
    s = new[3];
    `checkd($bits(s), 3 * 12);
    u = new[2];
    `checkd($bits(u), 2 * 3 * 32);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
