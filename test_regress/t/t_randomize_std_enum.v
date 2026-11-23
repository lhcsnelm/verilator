// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// std::randomize gives a variable of an enumeration type one of its values (IEEE 1800-2023 18.4)

module t;
  typedef enum logic [15:0] {N0 = 16'h1111, N1 = 16'h2222, N2 = 16'h3333} narrow_e;
  typedef enum logic [79:0] {
    W0 = {16'h1111, 64'h0},
    W1 = {16'h2222, 64'h5},
    W2 = {16'h3333, 64'h9}
  } wide_e;

  narrow_e n;
  narrow_e m;
  wide_e w;

  initial begin
    automatic int seen[narrow_e];
    int ok;
    repeat (100) begin
      ok = std::randomize(n);
      `checkd(ok, 1);
      `checkd(n inside {N0, N1, N2}, 1);
      ++seen[n];
      ok = std::randomize(w);
      `checkd(ok, 1);
      `checkd(w inside {W0, W1, W2}, 1);
      // Also with constraints, of the variable or not
      ok = std::randomize(n, m) with {n != N0;};
      `checkd(ok, 1);
      `checkd(n inside {N1, N2}, 1);
      `checkd(m inside {N0, N1, N2}, 1);
    end
    `checkd(seen.num(), 3);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
