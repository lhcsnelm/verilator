// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// The elements of a rand array of objects created in pre_randomize(), anew on each call, are
// randomized (IEEE 1800-2023 18.6.1)

class Base;
  rand int unsigned req_cnt;
endclass

class Host extends Base;
  rand bit [3:0] extra;
endclass

class Vseq;
  rand Host host_seq[];
  int unsigned n = 3;
  constraint req_cnt_c {
    foreach (host_seq[i]) {
      host_seq[i].req_cnt inside {[100 : 200]};
      host_seq[i].extra == 4'(i);
    }
  }
  function void pre_randomize();
    host_seq = new[n];
    foreach (host_seq[i]) host_seq[i] = new;
  endfunction
endclass

// Derived twice, so randomize() of each holds the registrations of all ancestors
class VseqMid extends Vseq;
  rand bit mid;
endclass

class VseqLeaf extends VseqMid;
  rand bit leaf;
endclass

module t;
  initial begin
    automatic VseqLeaf v = new;
    int ok;
    for (int round = 0; round < 3; ++round) begin
      v.n = round == 1 ? 2 : 3 + round;
      ok = v.randomize();
      `checkd(ok, 1);
      `checkd(v.host_seq.size(), v.n);
      foreach (v.host_seq[i]) begin
        if (v.host_seq[i].req_cnt < 100 || v.host_seq[i].req_cnt > 200) $stop;
        `checkd(v.host_seq[i].extra, 4'(i));
      end
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
