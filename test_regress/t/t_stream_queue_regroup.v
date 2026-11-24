// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkp(gotv,expv_s) do begin string gotv_s; gotv_s = $sformatf("%p", gotv); if ((gotv_s) != (expv_s)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv_s), (expv_s)); `stop; end end while(0);
// verilog_format: on

// A stream of a dynamic array or queue to a queue of other element width regroups its bits,
// the last element zero padded on the right (IEEE 1800-2023 11.4.14)

module t;
  initial begin
    bit q[$];
    byte unsigned data[];
    bit [3:0] nibbles[$];
    byte unsigned bytes[$];
    q = '{1, 0, 1, 1, 0, 0};
    data = '{8'h12, 8'h80};
    nibbles = {>>{q}};
    `checkp(nibbles, "'{'hb, 'h0}");
    nibbles = {>>{data}};
    `checkp(nibbles, "'{'h1, 'h2, 'h8, 'h0}");
    bytes = {>>{q}};
    `checkp(bytes, "'{'hb0}");
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
