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

// A packed value streamed into a queue, then read from it

module t;
  initial begin
    bit [27:0] src;
    bit bits[$];
    byte unsigned bytes[$];
    bit [7:0] pid;
    src = 28'hb412809;
    bits = {>>{src}};
    `checkh(bits.size(), 28);
    pid = {>>{bits[0:7]}};
    `checkh(pid, 8'hb4);
    bytes = {>>{src}};  // Last element zero padded on the right
    `checkp(bytes, "'{'hb4, 'h12, 'h80, 'h90}");
    bytes = {<<8{src}};  // Sliced from the right
    `checkp(bytes, "'{'h9, 'h28, 'h41, 'hb0}");
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
