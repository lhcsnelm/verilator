// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// Consecutive repetition in transition bins, 'v [*n]' and 'v [*m:n]' (IEEE 1800-2023 19.5.2)

module t;
  localparam int N = 3;

  covergroup cg with function sample (bit [2:0] v);
    cp : coverpoint v {
      bins fixed = (1 [*N]);  // Count from a parameter
      bins more = (1 [*4]);  // Not as many consecutive samples
      bins range = (2 [*2:3] => 3);  // Each count a sequence, the bin hit once per sample
      bins middle = (4 => 5 [*2] => 4);
      bins once = (3 [*1:2]);  // Also a single sample
      bins list = (6, 7 [*2]);  // Of each value of the list
      bins ends = (0 [*1:2] => 1 => 0 [*1:2]);
      ignore_bins ign = (7 [*3]);
    }
  endgroup

  cg c = new;

  initial begin
    static bit [2:0] values[] = '{1, 1, 1, 2, 2, 2, 3, 4, 5, 5, 4, 6, 7, 0, 0, 1, 0, 0, 0};
    foreach (values[i]) c.sample(values[i]);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
