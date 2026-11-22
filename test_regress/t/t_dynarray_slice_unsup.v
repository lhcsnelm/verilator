// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t;

  int d[];
  int part[];
  int n;

  initial begin
    d = new[4];
    part = d[n++ +:2];
  end

endmodule
