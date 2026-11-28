// DESCRIPTION: Verilator: Verilog Test module
//
// A process delays by #0 more times in one time step than the convergence limit
// for settling logic, while another counts its resumptions.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

module t;
  localparam int N = 30000;
  int resumed = 0;
  int other = 0;

  initial begin
    for (int i = 0; i < N; ++i) begin
      #0;
      ++resumed;
    end
  end

  initial begin
    #0;
    ++other;
  end

  initial begin
    #1;
    `checkd($time, 1);
    `checkd(resumed, N);
    `checkd(other, 1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
