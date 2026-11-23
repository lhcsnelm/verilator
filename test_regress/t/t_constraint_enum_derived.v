// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A random variable of an enumeration type, constrained in a base class, takes the values of
// the enumeration also when an object of a derived class is randomized (IEEE 1800-2023 18.4)

typedef enum logic [2:0] {L128 = 0, L224 = 1, L256 = 2, L384 = 3, L512 = 4} strength_e;

class Base;
  rand strength_e strength;
  rand int unsigned len;
  constraint strength_c {strength != L128;}
  constraint len_c {(strength == L224) -> (len == 28);}
endclass

class Derived extends Base;
  rand bit [3:0] other;
  constraint other_c {other < 5;}
endclass

class Overriding extends Base;
  constraint len_c {len < 100;}
endclass

module t;
  initial begin
    automatic Derived d = new;
    automatic Overriding o = new;
    automatic Base b = new;
    int ok;
    repeat (50) begin
      ok = d.randomize();
      `checkd(ok, 1);
      ok = o.randomize();
      `checkd(ok, 1);
      ok = b.randomize();
      `checkd(ok, 1);
      `checkd(d.strength inside {[L224 : L512]}, 1);
      `checkd(o.strength inside {[L224 : L512]}, 1);
      `checkd(b.strength inside {[L224 : L512]}, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
