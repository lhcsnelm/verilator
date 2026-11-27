// DESCRIPTION: Verilator: Verilog Test module
//
// A process stops once $finish has executed in a loop, or in a method it called, while
// other processes at that time, including other branches of the same fork, still run.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

module t;
  int rest_ran = 0;
  int other_ran = 0;

  class Fin;
    static function void finish();
      $finish;
    endfunction
  endclass

  initial begin
    while (rest_ran < 1000) begin
      $finish;
      ++rest_ran;
    end
  end

  initial begin
    ++other_ran;
    Fin::finish();
    ++rest_ran;
  end

  initial begin
    fork
      begin
        Fin::finish();
        ++rest_ran;
      end
      ++other_ran;
    join
  end

  final begin
    `checkd(rest_ran, 0);
    `checkd(other_ran, 2);
    $write("*-* All Finished *-*\n");
  end
endmodule
