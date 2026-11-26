// DESCRIPTION: Verilator: Verilog Test module
//
// With --x-initial-edge, initialization fires only the edges a 4-state simulator sees from X:
// a negedge for a signal starting at 0, no posedge, and no change of a never-written signal.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

module t;
  logic clk;  // Starts 0, never toggles
  logic rst_n;  // Starts 0, held in reset
  logic [1:0] csb;  // Never written
  logic [2:0] cnt;
  int posedges = 0;
  int edges = 0;
  int changes = 0;

  always @(posedge clk) ++posedges;
  always @(edge clk) ++edges;
  always @(posedge clk or negedge rst_n)
    if (!rst_n) cnt <= 3'd7;
    else cnt <= cnt - 3'd1;

  initial forever begin
    @(csb);
    ++changes;
  end

  initial begin
    #1;
    `checkd(cnt, 3'd7);
    `checkd(posedges, 0);
    `checkd(edges, 1);
    `checkd(changes, 0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
