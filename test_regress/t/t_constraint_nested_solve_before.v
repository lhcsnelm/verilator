// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A solve-before of an object nested two levels in the randomized one, which also constrains
// its members

class Inner;
  rand bit zero;
  rand int unsigned delay;
  constraint c {
    solve zero before delay;
    delay inside {[1 : 100]};
  }
endclass

class Mid;
  rand Inner inner;
  function new;
    inner = new;
  endfunction
endclass

class Outer;
  rand Mid mid;
  function new;
    mid = new;
  endfunction
  constraint c {
    if (!mid.inner.zero) mid.inner.delay inside {[1 : 3]};
  }
endclass

module t;
  initial begin
    automatic Outer o = new;
    int ok;
    repeat (20) begin
      ok = o.randomize();
      `checkd(ok, 1);
      if (!o.mid.inner.zero) `checkd(o.mid.inner.delay inside {[1 : 3]}, 1);
      `checkd(o.mid.inner.delay inside {[1 : 100]}, 1);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
