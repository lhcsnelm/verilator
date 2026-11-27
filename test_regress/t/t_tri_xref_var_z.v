// DESCRIPTION: Verilator: Verilog Test module
//
// An interface variable written z through a hierarchical reference releases the net
// it drives.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

interface ifc;
  logic drv;
  wire pin;
  assign pin = drv;
  pullup (pin);
endinterface

module t;
  ifc i ();
  initial begin
    i.drv = 1'bz;
    #1;
    `checkd(i.pin, 1'b1);
    i.drv = 1'b0;
    #1;
    `checkd(i.pin, 1'b0);
    i.drv = 1'bz;
    #1;
    `checkd(i.pin, 1'b1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
