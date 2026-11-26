// DESCRIPTION: Verilator: Verilog Test module
//
// Forced and procedurally assigned interface signals read through a virtual interface
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

interface tif;
  wire w;
  logic v;
  logic [7:0] bus;
  logic fa /*verilator forceable*/;
  logic pa;
  assign w = 1'b0;
endinterface

class Mon;
  virtual tif vif;
endclass

module t;
  tif i ();
  tif j ();  // Never forced
  logic src = 1'b1;
  Mon m = new;
  Mon n = new;

  initial begin
    m.vif = i;
    n.vif = j;
    i.v = 1'b0;
    i.bus = 8'h11;
    i.fa = 1'b0;
    i.pa = 1'b0;
    j.v = 1'b0;
    #1;
    force i.w = src;
    force i.v = 1'b1;
    force i.bus[3:0] = 4'hf;
    force i.fa = 1'b1;
    assign i.pa = src;
    #1;
    `checkh(m.vif.w, 1'b1);
    `checkh(m.vif.v, 1'b1);
    `checkh(m.vif.bus, 8'h1f);
    `checkh(m.vif.bus[3:0], 4'hf);
    `checkh(m.vif.fa, 1'b1);
    `checkh(m.vif.pa, 1'b1);
    `checkh(n.vif.w, 1'b0);
    `checkh(n.vif.v, 1'b0);
    release i.w;
    release i.v;
    release i.bus;
    release i.fa;
    deassign i.pa;
    #1;
    `checkh(m.vif.w, 1'b0);
    `checkh(m.vif.v, 1'b1);
    `checkh(m.vif.bus, 8'h1f);
    `checkh(m.vif.fa, 1'b1);
    `checkh(m.vif.pa, 1'b1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
