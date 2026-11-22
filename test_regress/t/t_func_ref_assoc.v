// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

package pkg;
  typedef struct {int len;} vec_t;
  function automatic void fill(string name, ref vec_t parsed[], input int base = 0);
    parsed = new[name.len()];
    foreach (parsed[i]) parsed[i].len = base + i;
  endfunction
  function automatic void incr(ref int value);
    ++value;
  endfunction
endpackage

module t;

  pkg::vec_t vecs[string][];
  int counts[string];
  int wild[*];

  initial begin
    // Elements of associative arrays passed by reference, created when missing
    pkg::fill("ab", vecs["ab"]);
    pkg::fill("xyz", vecs["xyz"], 10);
    `checkd(vecs.num(), 2);
    `checkd(vecs["ab"].size(), 2);
    `checkd(vecs["xyz"].size(), 3);
    `checkd(vecs["xyz"][2].len, 12);
    pkg::incr(counts["a"]);
    pkg::incr(counts["a"]);
    `checkd(counts["a"], 2);
    pkg::incr(wild[5]);
    `checkd(wild[5], 1);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
