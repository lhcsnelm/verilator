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
  bit [31:0] words[2];
  bit [7:0] bytes_d[];
  bit [7:0] bytes_q[$];

  initial begin
    bytes_d = '{8'h11, 8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88};
    words = {>>byte{bytes_d}};
    `checkh(words[0], 32'h11223344);
    `checkh(words[1], 32'h55667788);
    words = {<<byte{bytes_d}};
    `checkh(words[0], 32'h88776655);
    `checkh(words[1], 32'h44332211);

    bytes_q = '{8'h11, 8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88};
    words = {>>byte{bytes_q}};
    `checkh(words[0], 32'h11223344);
    `checkh(words[1], 32'h55667788);
    words = {<<byte{bytes_q}};
    `checkh(words[0], 32'h88776655);
    `checkh(words[1], 32'h44332211);

    // A shorter stream is left justified, padded with zeros
    bytes_q = '{8'haa, 8'hbb, 8'hcc};
    words = {>>byte{bytes_q}};
    `checkh(words[0], 32'haabbcc00);
    `checkh(words[1], 32'h0);
    words = {<<byte{bytes_q}};
    `checkh(words[0], 32'hccbbaa00);
    `checkh(words[1], 32'h0);

    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
