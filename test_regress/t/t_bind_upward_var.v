// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// An upward reference to a variable of the instance an interface is bound into, as by the
// module's name (IEEE 1800-2023 23.8)

typedef struct packed {
  logic [3:0] lo;
  logic [3:0] hi;
} info_t;

typedef struct packed {
  info_t info;
  logic [7:0] cnt;
} loop_t;

interface loop_if;
  function automatic logic [3:0] get_lo();
    return current_loop.info.lo;
  endfunction
  function automatic void force_lo(logic [3:0] v);
    force current_loop.info.lo = v;
  endfunction
endinterface

module ctrl #(
    parameter logic [3:0] Lo = 0
) ();
  loop_t current_loop;
  initial current_loop = '{info: '{lo: Lo, hi: 4'h4}, cnt: 8'h9};
endmodule

module t;
  ctrl #(.Lo(4'h3)) u_ctrl_a ();
  ctrl #(.Lo(4'h5)) u_ctrl_b ();
  bind ctrl loop_if i_loop_if ();

  initial begin
    #1;
    `checkh(u_ctrl_a.i_loop_if.get_lo(), 4'h3);
    `checkh(u_ctrl_b.i_loop_if.get_lo(), 4'h5);
    u_ctrl_b.i_loop_if.force_lo(4'h7);
    #1;
    `checkh(u_ctrl_a.current_loop.info.lo, 4'h3);
    `checkh(u_ctrl_b.current_loop.info.lo, 4'h7);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
