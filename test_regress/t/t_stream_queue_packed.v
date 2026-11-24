// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A stream of a dynamic array or queue is left justified in a wider fixed size target, of
// any width (IEEE 1800-2023 11.4.14)

module t;
  initial begin
    bit q[$];
    byte unsigned data[];
    bit [39:0] narrow;
    bit [255:0] wide;
    bit [7:0] unpacked[32];
    bit [255:0] unpacked_bits;
    q = '{1, 0, 1, 1, 0, 0};
    data = '{8'h12, 8'h80};

    narrow = {>>{q}};
    `checkh(narrow, 40'hb0_0000_0000);
    narrow = {<<{q}};
    `checkh(narrow, 40'h34_0000_0000);
    narrow = {<<8{data}};
    `checkh(narrow, 40'h80_1200_0000);

    wide = {>>{q}};
    `checkh(wide, {8'hb0, 248'h0});
    wide = {<<{q}};
    `checkh(wide, {8'h34, 248'h0});
    wide = {<<8{data}};
    `checkh(wide, {16'h8012, 240'h0});

    unpacked = {>>{data}};
    unpacked_bits = {>>{unpacked}};
    `checkh(unpacked_bits, {16'h1280, 240'h0});
    unpacked = {<<{q}};
    unpacked_bits = {>>{unpacked}};
    `checkh(unpacked_bits, {8'h34, 248'h0});
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
