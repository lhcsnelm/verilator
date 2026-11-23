// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Force and release of a net with tristate drivers, directly and through an interface

interface tl_if;
  wire [7:0] h2d;
  wire [7:0] d2h;
  logic [7:0] h2d_int = 8'h21;
  logic [7:0] d2h_int = 8'h11;
  bit host = 1;
  assign h2d = host ? h2d_int : 'z;
  assign d2h = !host ? d2h_int : 'z;
endinterface

module dut (
    input logic [7:0] tl_i,
    output logic [7:0] tl_o
);
  assign tl_o = tl_i + 8'h1;
endmodule

module t;
  wire [7:0] w;
  logic [7:0] x = 8'h31;
  bit en = 1;
  assign w = en ? x : 'z;

  tl_if u_if ();
  dut u_dut (
      .tl_i(),
      .tl_o()
  );

  initial begin
    #1;
    `checkh(w, 8'h31);
    force w = 8'h42;
    #1;
    `checkh(w, 8'h42);
    release w;
    #1;
    `checkh(w, 8'h31);

    `checkh(u_if.d2h, 8'hzz);
    force u_if.d2h = u_dut.tl_o;
    force u_dut.tl_i = u_if.h2d;
    #1;
    `checkh(u_if.d2h, 8'h22);
    u_if.h2d_int = 8'h50;
    #1;
    `checkh(u_if.d2h, 8'h51);
    release u_if.d2h;
    u_if.host = 0;
    #1;
    `checkh(u_if.d2h, 8'h11);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
