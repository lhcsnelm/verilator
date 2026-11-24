// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Streams into a dynamic array in an if/else, only the taken one evaluated

class base;
  bit [7:0] pid = 8'hd2;
endclass

class tok extends base;
  bit [6:0] addr = 7'h1b;
endclass

class sof extends base;
  bit [10:0] frame = 11'h123;
endclass

module t;
  function automatic int stream_size(base item);
    bit bits[];
    tok t;
    sof s;
    if ($cast(t, item)) bits = {>>{t.pid, t.addr}};
    else if ($cast(s, item)) bits = {>>{s.pid, s.frame}};
    else bits = {>>{item.pid}};
    return bits.size();
  endfunction

  initial begin
    tok t;
    sof s;
    base b;
    int size;
    t = new;
    s = new;
    b = new;
    size = stream_size(t);
    `checkd(size, 15);
    size = stream_size(s);
    `checkd(size, 19);
    size = stream_size(b);  // Null s, t must not be dereferenced
    `checkd(size, 8);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
