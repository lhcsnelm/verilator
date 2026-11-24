// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
`define checkp(gotv,expv_s) do begin string gotv_s; gotv_s = $sformatf("%p", gotv); if ((gotv_s) != (expv_s)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv_s), (expv_s)); `stop; end end while(0);
// verilog_format: on

// Unpacking into streaming concatenations with dynamic arrays and queues: the first takes the
// whole elements before the fixed size operands after it, later ones none (IEEE 1800-2023
// 11.4.14.4)

class pkt;
  bit [7:0] pid;
  byte unsigned data[];
  bit [15:0] crc;
  function void unpack(bit bits[]);
    {>>{pid, data, crc}} = bits;
  endfunction
endclass

module t;
  bit [7:0] pid_nba;
  byte unsigned data_nba[];

  initial begin
    pkt p;
    bit [7:0] pid;
    byte unsigned data[];
    byte unsigned rest[$];
    bit [3:0] crc;
    bit bits[];
    byte unsigned bytes[$];
    bit [128:0] wide_q[$];
    bit [63:0] word;
    int hi, lo;

    {>>{pid, data}} = 28'hb412809;  // Last bits not a whole element
    `checkh(pid, 8'hb4);
    `checkp(data, "'{'h12, 'h80}");
    {>>{pid, data, crc}} = 28'hb412809;
    `checkh(pid, 8'hb4);
    `checkp(data, "'{'h12, 'h80}");
    `checkh(crc, 4'h9);
    {>>{data, crc}} = 28'hb412809;
    `checkp(data, "'{'hb4, 'h12, 'h80}");
    `checkh(crc, 4'h9);
    rest = '{8'h1};
    {>>{pid, data, rest}} = 28'hb412809;
    `checkp(data, "'{'h12, 'h80}");
    `checkp(rest, "'{}");
    {<<8{pid, data}} = 24'h123456;
    `checkh(pid, 8'h56);
    `checkp(data, "'{'h34, 'h12}");

    bits = '{1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1};
    {>>{pid, data}} = bits;  // No whole element left
    `checkh(pid, 8'hb4);
    `checkp(data, "'{}");
    {>>{crc, data}} = bits;
    `checkh(crc, 4'hb);
    `checkp(data, "'{'h4f}");

    bytes = '{8'hb4, 8'h01, 8'h02};
    {>>{pid, data}} = bytes;
    `checkh(pid, 8'hb4);
    `checkp(data, "'{'h1, 'h2}");
    {>>{pid_nba, data_nba}} <= bytes;
    #1;
    `checkh(pid_nba, 8'hb4);
    `checkp(data_nba, "'{'h1, 'h2}");

    // Fixed size targets from a dynamically sized source, the stream's extra bits ignored
    wide_q = '{129'h1_2345_6789_abcd_ef01_0000_0000_0000_0000};
    {>>{word}} = wide_q;
    `checkh(word, 64'h91a2b3c4_d5e6f780);
    {>>{hi, lo}} = wide_q;
    `checkh(hi, 32'h91a2b3c4);
    `checkh(lo, 32'hd5e6f780);

    p = new;
    bits = {>>{32'hb4128011}};
    p.unpack(bits);
    `checkh(p.pid, 8'hb4);
    `checkp(p.data, "'{'h12}");
    `checkh(p.crc, 16'h8011);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
