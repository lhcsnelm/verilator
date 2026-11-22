// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Processes forked from a module or package, running at the same time, each have their own
// automatic variables, also when they fork again

package pkg;
  class Reg;
    int val;
    function new(int v);
      val = v;
    endfunction
    task read(output int value);
      #1 value = val;
    endtask
  endclass

  int mismatches = 0;
  int checks = 0;

  // As a register read with a timeout
  task automatic rd_sub(input Reg r, output int value);
    int value_local;
    fork
      begin : isolation
        fork
          r.read(value_local);
          #10;
        join_any
        disable fork;
      end
    join
    value = value_local;
  endtask

  // As a register read and check, optionally returning before the check
  task automatic rd_check(input Reg r, input bit blocking, input int exp);
    fork
      begin : isolation
        fork
          begin
            int obs;
            rd_sub(r, obs);
            ++checks;
            if (obs != exp) ++mismatches;
          end
        join_none
        if (blocking) wait fork;
        else #0;
      end
    join
  endtask
endpackage

class Seq;
  task body();
    pkg::Reg regs[4];
    foreach (regs[i]) regs[i] = new(10 + i);
    foreach (regs[i]) pkg::rd_check(regs[i], 1, 10 + i);
    foreach (regs[i]) pkg::rd_check(regs[i], 0, 10 + i);
  endtask
endclass

module t;
  int sum_block = 0;
  int sum_task = 0;

  task automatic times10(input int x, output int v);
    int l;
    fork
      #1 l = x * 10;
    join
    v = l;
  endtask

  initial begin
    automatic Seq seq = new;
    for (int i = 1; i <= 3; ++i) begin
      fork
        begin
          automatic int k = i;
          automatic int l;
          #1;
          fork
            #1 l = k * 10;
          join
          sum_block += l;
        end
        begin
          automatic int k = i;
          int r;
          #1;
          times10(k, r);
          sum_task += r;
        end
      join_none
    end
    seq.body();
    #20;
    `checkd(sum_block, 60);
    `checkd(sum_task, 60);
    `checkd(pkg::checks, 8);
    `checkd(pkg::mismatches, 0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
