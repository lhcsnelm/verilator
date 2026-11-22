// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
`define checks(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

typedef enum {
  StA,
  StB
} state_e;

interface ifc;
  // Members of types without fixed size, written through a virtual interface
  bit [7:0] keys[state_e][string];
  int q[$];
  string name;
endinterface

class Driver;
  virtual ifc vif;
  function new(virtual ifc vif);
    this.vif = vif;
  endfunction
  task run();
    vif.keys[StB]["k"] = 8'h5a;
    vif.q.push_back(3);
    vif.name = "abc";
  endtask
endclass

module t;

  ifc u_ifc ();

  initial begin
    automatic Driver drv = new(u_ifc);
    drv.run();
    #1;
    `checkh(drv.vif.keys[StB]["k"], 8'h5a);
    `checkh(drv.vif.q.size(), 1);
    `checks(drv.vif.name, "abc");
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
