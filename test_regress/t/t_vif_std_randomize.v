// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// std::randomize() state of an interface used through a virtual interface
interface ifc;
  int x;
  function void pick();
    void'(std::randomize(x) with {x < 10;});
  endfunction
endinterface
class Driver;
  virtual ifc vif;
  function new(virtual ifc vif);
    this.vif = vif;
  endfunction
  task run();
    vif.pick();
  endtask
endclass
module t;
  ifc u_ifc ();
  initial begin
    automatic Driver drv = new(u_ifc);
    drv.run();
    #1;
    if (drv.vif.x >= 10) $stop;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
