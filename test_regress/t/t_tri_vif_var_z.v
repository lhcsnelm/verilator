// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A variable a class writes z to through a virtual interface releases the net it drives

interface pins_if (
    inout wire [1:0] pins
);
  bit connected = 1;
  logic [1:0] drive;
  assign pins = connected ? drive : 'z;
  assign (weak0, weak1) pins = 2'b11;  // Pull-ups, seen when released
  modport drv(output drive);
endinterface

class item;
  logic [1:0] value;
endclass

class driver;
  virtual pins_if.drv vif;
  item last = new;
  function new(virtual pins_if.drv vif);
    this.vif = vif;
  endfunction
  task drive(logic [1:0] value);
    vif.drive = value;
  endtask
  task release_all();
    vif.drive = 'z;
    last.value = 'z;  // A class member, not a virtual interface's
  endtask
  task release_nba();
    vif.drive <= 2'bzz;
  endtask
  task release_bit();
    vif.drive[0] = 1'bz;
  endtask
  task drive_if(bit en, logic [1:0] value);
    vif.drive = en ? value : 2'bzz;
  endtask
endclass

module t;
  wire [1:0] pins;
  pins_if u_if (.pins(pins));

  initial begin
    driver d;
    d = new(u_if);
    d.drive(2'b00);
    #1 `checkh(pins, 2'b00);
    d.release_all();
    #1 `checkh(pins, 2'b11);
    d.drive(2'b01);
    #1 `checkh(pins, 2'b01);
    d.release_nba();
    #1 `checkh(pins, 2'b11);
    d.drive(2'b00);
    d.release_bit();
    #1 `checkh(pins, 2'b01);
    d.drive_if(1'b1, 2'b10);
    #1 `checkh(pins, 2'b10);
    d.drive_if(1'b0, 2'b10);
    #1 `checkh(pins, 2'b11);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
