// DESCRIPTION: Verilator: Verilog Test module
//
// Bit-stream casts between unpacked arrays of which one is dynamically sized.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

module t;
  typedef bit bits_t[];
  typedef byte unsigned bytes_t[$];
  typedef bit [3:0] nibbles_t[4];
  initial begin
    byte unsigned data[];
    bits_t bits;
    bytes_t bytes;
    nibbles_t nibbles;
    int words[2];
    data = '{8'h01, 8'h80};
    bits = bits_t'(data);
    `checkd(bits.size(), 16);
    `checkd(bits[7], 1'b1);
    `checkd(bits[8], 1'b1);
    `checkd(bits[0], 1'b0);
    bytes = bytes_t'(bits);
    `checkd(bytes.size(), 2);
    `checkd(bytes[0], 8'h01);
    `checkd(bytes[1], 8'h80);
    nibbles = nibbles_t'(data);
    `checkd(nibbles[1], 4'h1);
    `checkd(nibbles[2], 4'h8);
    // From fixed-size arrays, of the same or of other elements
    bytes = bytes_t'(nibbles);
    `checkd(bytes.size(), 2);
    `checkd(bytes[1], 8'h80);
    words = '{32'h01020304, 32'h05060708};
    bytes = bytes_t'(words);
    `checkd(bytes.size(), 8);
    `checkd(bytes[0], 8'h01);
    `checkd(bytes[7], 8'h08);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
