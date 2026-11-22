// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t;
  int count = 2;

  covergroup cg with function sample (bit [2:0] v);
    cp : coverpoint v {
      bins zero = (1 [*0]);
      bins order = (1 [*3:2]);
      bins variable = (1 [*count]);
    }
  endgroup

  cg c = new;
endmodule
