// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t;
  covergroup cg with function sample (bit [2:0] v);
    cp : coverpoint v {
      bins big = (1 [*1:1000] => 2 [*1:1000]);
    }
  endgroup

  cg c = new;
endmodule
