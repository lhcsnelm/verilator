// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module t;

  logic d[];
  logic part[];
  int q[$];
  int qpart[$];

  initial begin
    d = new[16];
    foreach (d[i]) d[i] = i[0];

    // Range select of a dynamic array
    part = d[4:7];
    `checkh(part.size(), 4);
    `checkh({part[0], part[1], part[2], part[3]}, 4'b0101);

    // Indexed selects with a variable base, read and written
    for (int i = 0; i < 2; ++i) begin
      part = d[i*8+:8];
      `checkh(part.size(), 8);
      `checkh(part[1], 1'b1);
      foreach (part[j]) part[j] = ~part[j];
      d[i*8+:8] = part;
    end
    `checkh(d[0], 1'b1);
    `checkh(d[15], 1'b0);
    part = d[15-:4];
    `checkh(part.size(), 4);
    `checkh({part[0], part[1], part[2], part[3]}, 4'b1010);

    q = '{10, 11, 12, 13, 14};
    for (int i = 1; i < 2; ++i) begin
      qpart = q[i+:3];
      `checkh(qpart.size(), 3);
      `checkh(qpart[0], 11);
      qpart = q[i+2-:2];
      `checkh(qpart.size(), 2);
      `checkh(qpart[1], 13);
      q[i+:2] = '{20, 21};
    end
    `checkh(q[1], 20);
    `checkh(q[2], 21);
    `checkh(q[3], 13);

    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
