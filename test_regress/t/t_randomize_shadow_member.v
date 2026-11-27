// DESCRIPTION: Verilator: Verilog Test module
//
// A derived class redeclares a rand member of its base class, and each
// constraint applies to the member it names.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Base;
  rand bit [15:0] w;
  rand bit [7:0] other;
  constraint w_c {w inside {[1 : 10]};}
  constraint base_c {other == w[7:0];}
endclass

class Derived extends Base;
  rand bit [15:0] w;
  constraint w_c {w inside {[50 : 100]};}
endclass

class Again extends Derived;
  rand bit [15:0] w;
  constraint again_c {w == super.w + 1;}
endclass

module t;
  initial begin
    Derived d;
    Again a;
    Base b;
    Derived ad;
    int ok;
    d = new;
    a = new;
    repeat (5) begin
      ok = d.randomize();
      `checkd(ok, 1);
      `checkd(d.w inside {[50 : 100]}, 1);
      b = d;
      `checkd(b.other, b.w[7:0]);
      ok = a.randomize();
      `checkd(ok, 1);
      ad = a;
      `checkd(a.w, ad.w + 1);
      `checkd(ad.w inside {[50 : 100]}, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
