// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t;
  import "DPI-C" function int dpic_sum(int n);
  initial begin
    if (dpic_sum(5) != 10) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
