// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t (
    input a,
    input b,
    input c,
    output wire w
);
  // Unequal strengths on a value that may be 0, 1 or z
  assign (strong0, pull1) w = a ? b : 1'bz;
  assign (weak0, weak1) w = c;
endmodule
