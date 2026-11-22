// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module t;

  logic en;
  logic d;
  logic pu_en;
  logic [3:0] mix;

  // Weak pullup behind a strong tristate driver
  wire pulled;
  pullup (weak1) pu_i (pulled);
  wire pd_net;
  pulldown (pull0, weak1) pd_i (pd_net);
  assign pulled = en ? d : 1'bz;

  // Pull to 1 only when the driver is off
  wire sio;
  assign sio = en ? d : 1'bz;
  assign (highz0, pull1) sio = !en;

  // Pullup of unequal strengths, against strong drivers
  wire usb;
  assign (strong0, strong1) usb = en ? d : 1'bz;
  assign (weak0, pull1) usb = pu_en ? 1'b1 : 1'bz;

  // Variable value of unequal strengths: its 1s beat the pull, its 0s lose to it
  wire [3:0] bus;
  assign (weak0, strong1) bus = mix;
  assign (pull0, pull1) bus = 4'b0101;

  initial begin
    en = 1'b1;
    d = 1'b0;
    pu_en = 1'b1;
    mix = 4'b0011;
    #1;
    `checkh(pulled, 1'b0);
    `checkh(sio, 1'b0);
    `checkh(usb, 1'b0);
    `checkh(bus, 4'b0111);
    en = 1'b0;
    #1;
    `checkh(pulled, 1'b1);
    `checkh(sio, 1'b1);
    `checkh(usb, 1'b1);
    pu_en = 1'b0;
    mix = 4'b1000;
    #1;
    `checkh(usb, 1'bz);
    `checkh(bus, 4'b1101);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
