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
  logic [3:0] en;
  logic [3:0] out;
  logic drv;
  wire [3:0] sio;
  wire [1:0] w;

  // Per-bit tristate drivers with a pull-up only when not driven
  for (genvar i = 0; i < 4; i++) begin : gen_tri
    assign sio[i] = en[i] ? out[i] : 1'bz;
    assign (highz0, pull1) sio[i] = !en[i];
  end

  // Weak driver on a select, overridden by a strong one
  assign (pull0, pull1) w[0] = 1'b1;
  assign w[0] = drv;
  assign (weak0, weak1) w[1] = 1'b0;

  initial begin
    en = 4'b0000;
    out = 4'b0000;
    drv = 1'b0;
    #1;
    `checkh(sio, 4'b1111);
    `checkh(w, 2'b00);
    en = 4'b0101;
    drv = 1'b1;
    #1;
    `checkh(sio, 4'b1010);
    `checkh(w, 2'b01);
    en = 4'b1111;
    out = 4'b1001;
    #1;
    `checkh(sio, 4'b1001);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
