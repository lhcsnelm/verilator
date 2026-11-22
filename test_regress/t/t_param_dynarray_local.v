// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
`define checks(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

package pkg;
  parameter bit [7:0] READ_A = 8'h03;
  parameter bit [7:0] READ_B = 8'h0b;
  // Package parameters are local, so these are not overridden
  parameter bit [7:0] READ_LIST[] = {READ_A, READ_B};
  parameter string NAMES[] = {"x", "yy", "zzz"};
  parameter int QUEUE[$] = {1, 2, 3, 4};
endpackage

class Cls;
  static function bit is_read(bit [7:0] cmd);
    return cmd inside {pkg::READ_LIST};
  endfunction
endclass

module t;

  localparam int LOCAL_LIST[] = '{10, 20};

  initial begin
    automatic bit [7:0] cmd = 8'h0b ^ 8'($urandom_range(0, 0));
    automatic int sum = 0;
    `checkh(pkg::READ_LIST.size(), 2);
    `checkh(cmd inside {pkg::READ_LIST}, 1'b1);
    `checkh(Cls::is_read(cmd), 1'b1);
    `checkh(Cls::is_read(8'h04), 1'b0);
    `checks(pkg::NAMES[1], "yy");
    foreach (pkg::QUEUE[i]) sum += pkg::QUEUE[i];
    `checkh(sum, 10);
    `checkh(LOCAL_LIST[1], 20);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
