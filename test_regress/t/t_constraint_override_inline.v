// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

class Base;
  rand int unsigned delay;
  rand int unsigned num;
  extern constraint delay_c;
  constraint num_c {num inside {[1 : 20]};}
  // Randomizing a member makes the class use rand modes
  function void pick_num();
    if (this.randomize(num) == 0) $stop;
  endfunction
endclass

constraint Base::delay_c {
  delay dist {
    [1 : 1000] :/ 1,
    [1001 : 100_000] :/ 2
  };
}

class Mid extends Base;
endclass

class Derived extends Mid;
  // Override the constraints of the same names
  constraint num_c {num inside {[1 : 2]};}
  constraint delay_c {
    delay dist {
      [1 : 100] :/ 1,
      [101 : 2_000] :/ 6,
      [2_001 : 10_000] :/ 1
    };
  }
endclass

module t;
  initial begin
    automatic Derived obj = new;
    repeat (20) begin
      if (obj.randomize() == 0) $stop;
      if (obj.num < 1 || obj.num > 2) $stop;
      if (obj.delay < 1 || obj.delay > 10_000) $stop;
    end
    obj.pick_num();
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
