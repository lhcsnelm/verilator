// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A declaration before super.new with an initializer of a constant, as of an enum method, is
// not a statement (IEEE 1800-2023 8.15)

typedef enum {A, B, C} e_t;

class Base;
  int v;
  function new(int v);
    this.v = v;
  endfunction
endclass

class Cls extends Base;
  e_t e;
  function new();
    e_t first = first.first;
    e_t last = last.last;
    super.new(7);
    e = last;
    `checkd(first, A);
  endfunction
endclass

module t;
  initial begin
    automatic Cls c = new;
    `checkd(c.v, 7);
    `checkd(c.e, C);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
