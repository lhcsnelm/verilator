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

  logic [7:0] narrow;
  logic [127:0] wide;
  logic [127:0] back;
  logic ld[];
  bit bd1[];
  logic [3:0] nd[];
  logic [7:0] bd[];
  logic [63:0] d64[];
  logic [127:0] d128[];

  initial begin
    // Not constants, so the assignments are not folded away
    narrow = 8'b1000_0011 ^ 8'($urandom_range(0, 0));
    wide = {32'h01234567, 32'h89abcdef, 32'hdeadbeef, 32'h00c0ffee} ^ 128'($urandom_range(0, 0));

    // Element 0 takes the MSB of the stream
    ld = {>>{narrow}};
    `checkh(ld.size(), 8);
    `checkh({ld[0], ld[1], ld[6], ld[7]}, 4'b1011);
    ld = {<<{narrow}};
    `checkh(ld.size(), 8);
    `checkh({ld[0], ld[1], ld[6], ld[7]}, 4'b1101);
    bd1 = {<<{narrow}};
    `checkh(bd1.size(), 8);
    `checkh({bd1[0], bd1[1], bd1[6], bd1[7]}, 4'b1101);

    // Wider elements, and a slice size
    nd = {>>{narrow}};
    `checkh(nd.size(), 2);
    `checkh(nd[0], 4'h8);
    `checkh(nd[1], 4'h3);
    nd = {<<4{narrow}};
    `checkh(nd[0], 4'h3);
    `checkh(nd[1], 4'h8);

    // Wide sources
    ld = {<<{wide}};
    `checkh(ld.size(), 128);
    `checkh(ld[0], 1'b0);
    `checkh(ld[1], 1'b1);
    `checkh(ld[127], 1'b0);
    back = {<<{ld}};
    `checkh(back, wide);
    bd = {>>{wide}};
    `checkh(bd.size(), 16);
    `checkh(bd[0], 8'h01);
    `checkh(bd[15], 8'hee);

    // A partly filled element is padded on the right
    d64 = {>>{narrow}};
    `checkh(d64.size(), 1);
    `checkh(d64[0], 64'h83000000_00000000);
    d128 = {>>{narrow}};
    `checkh(d128.size(), 1);
    `checkh(d128[0], {8'h83, 120'h0});
    d128 = {>>{64'(narrow)}};
    `checkh(d128[0], {64'h83, 64'h0});
    d64 = {<<{narrow}};
    `checkh(d64.size(), 1);
    `checkh(d64[0], 64'hc1000000_00000000);
    nd = {>>{narrow[6:0]}};
    `checkh(nd.size(), 2);
    `checkh(nd[0], 4'h0);
    `checkh(nd[1], 4'h6);

    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
