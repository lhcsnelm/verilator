// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A drive of a part of a clockvar drives only that part (IEEE 1800-2023 14.16), so it does
// not restore other parts the signal was assigned since

typedef struct packed {
  logic valid;
  logic [7:0] data;
  logic ready;
} bus_t;

interface ifc (
    input logic clk
);
  bus_t bus;
  logic [7:0] vec;
  logic [7:0] skewed;
  clocking cb @(posedge clk);
    output bus;
    output vec;
    output #2 skewed;
  endclocking
endinterface

class Driver;
  virtual ifc vif;
  function new(virtual ifc vif);
    this.vif = vif;
  endfunction
  task send(logic [7:0] data);
    vif.cb.bus.valid <= 1'b1;
    vif.cb.bus.data <= data;
    @(vif.cb);
    // Cleared directly, not through the clocking block, after the drive took effect
    #1 vif.bus.valid <= 1'b0;
  endtask
  task ready();
    vif.cb.bus.ready <= 1'b1;
    @(vif.cb);
  endtask
endclass

module t;
  logic clk = 0;
  always #5 clk = ~clk;

  ifc u_ifc (.clk(clk));

  initial begin
    automatic Driver drv = new(u_ifc);
    u_ifc.bus = '0;
    u_ifc.vec = '0;
    @(u_ifc.cb);
    u_ifc.cb.bus.valid <= 1'b1;
    u_ifc.cb.bus.data <= 8'h5a;
    @(u_ifc.cb);
    #1;
    `checkh(u_ifc.bus, {1'b1, 8'h5a, 1'b0});
    u_ifc.bus <= '0;
    @(u_ifc.cb);
    u_ifc.cb.bus.ready <= 1'b1;
    @(u_ifc.cb);
    #1;
    `checkh(u_ifc.bus, {1'b0, 8'h00, 1'b1});
    // Bit selects
    u_ifc.cb.vec[0] <= 1'b1;
    @(u_ifc.cb);
    u_ifc.vec[7] = 1'b1;
    u_ifc.cb.vec[3:2] <= 2'b11;
    @(u_ifc.cb);
    #1;
    `checkh(u_ifc.vec, 8'b1000_1101);
    // With an output skew
    u_ifc.skewed = '0;
    u_ifc.cb.skewed[1] <= 1'b1;
    @(u_ifc.cb);
    #1;
    u_ifc.skewed[6] = 1'b1;
    #2;
    u_ifc.cb.skewed[4] <= 1'b1;
    @(u_ifc.cb);
    #3;
    `checkh(u_ifc.skewed, 8'b0101_0010);
    // Through a virtual interface
    u_ifc.bus = '0;
    drv.send(8'hc3);
    drv.ready();
    #1;
    `checkh(u_ifc.bus, {1'b0, 8'hc3, 1'b1});
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
