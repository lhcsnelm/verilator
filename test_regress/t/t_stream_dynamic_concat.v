// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkp(gotv,expv_s) do begin string gotv_s; gotv_s = $sformatf("%p", gotv); if ((gotv_s) != (expv_s)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv_s), (expv_s)); `stop; end end while(0);
// verilog_format: on

// Streaming concatenations of packed values with dynamic arrays and queues

module t;
  initial begin
    bit [7:0] pid;
    byte unsigned data[];
    bit [3:0] crc;
    bit q[$];
    bit bits[];
    byte unsigned bytes[];
    byte unsigned bytes_q[$];
    pid = 8'hb4;
    data = '{8'h12, 8'h80};
    crc = 4'h9;
    q = '{1, 1, 0};

    bits = {>>{pid, data, crc}};
    `checkp(bits, "'{'h1, 'h0, 'h1, 'h1, 'h0, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h0, 'h1}");
    bits = {<<{pid, data, crc}};
    `checkp(bits, "'{'h1, 'h0, 'h0, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h1, 'h0, 'h0, 'h1, 'h0, 'h0, 'h0, 'h0, 'h0, 'h1, 'h0, 'h1, 'h1, 'h0, 'h1}");
    bytes = {>>{pid, data, crc}};
    `checkp(bytes, "'{'hb4, 'h12, 'h80, 'h90}");
    bytes = {<<8{pid, data}};
    `checkp(bytes, "'{'h80, 'h12, 'hb4}");
    bytes_q = {>>{data, q, crc, q}};  // Dynamic operands first and last
    `checkp(bytes_q, "'{'h12, 'h80, 'hd3, 'h80}");
    data.delete();
    bytes = {>>{pid, data}};  // Empty dynamic array
    `checkp(bytes, "'{'hb4}");
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
