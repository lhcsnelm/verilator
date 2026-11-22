// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

class Cls;
  static int s_depth = 3;
  int d;
  function new(int depth = s_depth);
    d = depth;
  endfunction
endclass

module t;

  initial begin
    Cls c;
    c = new;
  end

endmodule
