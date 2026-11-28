// DESCRIPTION: Verilator: Verilog Test module
//
// An unsized '1 item or range bound of inside and dist takes the width of the
// value it is compared to, not the width of the other items.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

module t;
  bit [3:0] mask;
  initial begin
    mask = 4'hf;
    `checkd(mask inside {'1, [0 : 14]}, 1'b1);
    `checkd(mask inside {[0 : 14], '1}, 1'b1);
    `checkd(mask inside {['1 : 15]}, 1'b1);
    repeat (10) begin
      `checkd(std::randomize(mask) with { mask dist {'1 :/ 100, [0 : 14] :/ 0}; }, 1);
      `checkd(mask, 4'hf);
      mask = 0;
      `checkd(std::randomize(mask) with { mask dist {[0 : 14] := 0, '1 := 1}; }, 1);
      `checkd(mask, 4'hf);
      mask = 0;
      `checkd(std::randomize(mask) with { mask inside {'1, [0 : 0]}; mask != 0; }, 1);
      `checkd(mask, 4'hf);
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
