// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

class Base;
  int d, td, sd;
  // Defaults reading earlier arguments
  function new(int depth, int tile_depth = depth, int scaled = tile_depth * 2 + 1);
    d = depth;
    td = tile_depth;
    sd = scaled;
  endfunction
endclass

class Derived extends Base;
  function new(int depth, int tile_depth = depth);
    super.new(depth, tile_depth);
  endfunction
endclass

module t;

  initial begin
    Base b;
    Derived x;
    b = new(5);
    `checkd(b.d, 5);
    `checkd(b.td, 5);
    `checkd(b.sd, 11);
    b = new(5, 3);
    `checkd(b.td, 3);
    `checkd(b.sd, 7);
    b = new(.depth(4), .scaled(1));
    `checkd(b.td, 4);
    `checkd(b.sd, 1);
    x = new(7);
    `checkd(x.td, 7);
    `checkd(x.sd, 15);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
