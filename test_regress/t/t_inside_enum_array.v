// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A value of one enum type inside an array of another, which compares their values
// (IEEE 1800-2023 11.4.13)

package p;
  typedef enum logic [3:0] {A0 = 1, A1 = 2} a_e;
  typedef enum logic [3:0] {B0 = 1, B1 = 2, B2 = 3} b_e;
  const a_e Valid[] = '{A0, A1};
endpackage

class Cls;
  rand p::b_e x;
  constraint c {x inside {p::Valid};}
endclass

module t;
  p::b_e y;
  initial begin
    automatic Cls c = new;
    int ok;
    repeat (20) begin
      ok = c.randomize();
      `checkd(ok, 1);
      `checkd(c.x inside {p::B0, p::B1}, 1);
    end
    y = p::B1;
    `checkd(y inside {p::Valid}, 1);
    y = p::B2;
    `checkd(y inside {p::Valid}, 0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
