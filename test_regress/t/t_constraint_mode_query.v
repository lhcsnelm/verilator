// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

class Cls;
  rand int x;
  constraint legal_c {x < 10;}
  function void check();
    // The query form is a function returning int (IEEE 1800-2023 18.9)
    `checkd(legal_c.constraint_mode(), 1);
    `checkd(!legal_c.constraint_mode(), 0);
    legal_c.constraint_mode(0);
    `checkd(!legal_c.constraint_mode(), 1);
    `checkd(legal_c.constraint_mode() + 2, 2);
  endfunction
endclass

module t;

  initial begin
    automatic Cls c = new;
    c.check();
    `checkd(c.legal_c.constraint_mode() ? 5 : 6, 6);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
