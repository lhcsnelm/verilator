// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// Members named as methods of the C++ class, also when public
class Reg;
  int init;
  int to_string;
  function new(int v);
    init = v;
    to_string = v + 1;
  endfunction
endclass

module t;

  initial begin
    automatic Reg r = new(5);
    if (r.init != 5 || r.to_string != 6) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
