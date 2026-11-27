// DESCRIPTION: Verilator: Verilog Test module
//
// A specialization of a parameterized class is the same type however its parameters are
// given: named in any order, positionally, or left to their defaults.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

class Root;
endclass

class Base #(
    type A = int,
    type B = int,
    int W = 1
) extends Root;
  function bit castable(Root r);
    Base #(A, B, W) h;
    return $cast(h, r);
  endfunction
endclass

class Named extends Base #(.W(2), .B(string), .A(byte));
endclass

class Defaulted extends Base #(.B(string));
endclass

module t;
  initial begin
    Named n;
    Defaulted d;
    Base #(byte, string, 2) bn;
    Base #(int, string) bd;
    Root r;
    n = new;
    d = new;
    if (!n.castable(n)) $stop;
    if (!d.castable(d)) $stop;
    r = n;
    if (!$cast(bn, r)) $stop;
    r = d;
    if (!$cast(bd, r)) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
