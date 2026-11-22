// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

package p;
  parameter int unsigned W = 33;
endpackage

// Default of B depends on A
class C #(
    parameter int A = 32,
    parameter int B = A + 1
);
  typedef C#(A, B) this_type;
  static function this_type create();
    this_type t = new;
    return t;
  endfunction
endclass

module t;

  C c0;  // Default specialization, so the class itself, used first
  C #(.A(p::W)) c1;
  C #(33, 34) c2;
  C #(33, 35) c3;

  initial begin
    // A parameter set to the value its default would take is the same specialization
    c0 = new;
    `checkd(c0.B, 33);
    c1 = C#(.A(p::W))::create();
    c2 = c1;
    c1 = c2;
    `checkd(c1.B, 34);
    c3 = new;
    `checkd(c3.B, 35);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
