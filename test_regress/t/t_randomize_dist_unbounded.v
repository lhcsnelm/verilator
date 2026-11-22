// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

typedef bit [2:0] dest_t;

class Cls;
  rand dest_t dest;
  rand byte signed sb;
  constraint dest_c {
    dest dist {[0:3] :/ 4, [4:$] :/ 2};
  }
  constraint sb_c {
    sb dist {[$:-100] :/ 1, [100:$] :/ 1};
  }
endclass

module t;

  initial begin
    automatic Cls c = new;
    automatic int high = 0;
    repeat (100) begin
      if (!c.randomize()) $stop;
      if (c.dest >= 4) ++high;
      if (c.sb > -100 && c.sb < 100) $stop;
    end
    // Values 4 to 7, the type's greatest, are chosen
    if (high == 0) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
