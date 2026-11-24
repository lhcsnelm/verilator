// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkp(gotv,expv_s) do begin string gotv_s; gotv_s = $sformatf("%p", gotv); if ((gotv_s) != (expv_s)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv_s), (expv_s)); `stop; end end while(0);
// verilog_format: on

// Streaming an unpacked array into a queue of elements of another width

module t;
  bit [31:0] asc[2];
  bit [31:0] desc[1:0];
  bit [7:0] bytes[$];
  bit [15:0] halves[$];

  initial begin
    asc[0] = 32'h11223344;
    asc[1] = 32'h55667788;
    desc[1] = 32'h11223344;
    desc[0] = 32'h55667788;

    bytes = {<<32{asc}};
    `checkp(bytes, "'{'h55, 'h66, 'h77, 'h88, 'h11, 'h22, 'h33, 'h44}");
    bytes = {>>{asc}};
    `checkp(bytes, "'{'h11, 'h22, 'h33, 'h44, 'h55, 'h66, 'h77, 'h88}");
    halves = {>>{asc}};
    `checkp(halves, "'{'h1122, 'h3344, 'h5566, 'h7788}");
    bytes = {>>{desc}};
    `checkp(bytes, "'{'h11, 'h22, 'h33, 'h44, 'h55, 'h66, 'h77, 'h88}");

    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
