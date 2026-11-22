// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// A force by a function, called through a virtual interface, of an expression of its arguments

module sub;
  logic [3:0] idx;
  logic [127:0] tok;
  assign idx = 4'h1;
  assign tok = '0;
endmodule

interface ifc;
  function static void force_idx(input int which, input logic [3:0] val);
    case (which)
      0: force t.u_sub.idx = val;
      default: ;
    endcase
  endfunction
  function automatic void force_tok(input logic [127:0] val, input int add);
    force t.u_sub.tok = val + 128'(add);
  endfunction
endinterface

class Driver;
  virtual ifc vif;
  task run();
    vif.force_idx(0, 4'h7);
    vif.force_tok({4{32'hcafe_f00d}}, 2);
  endtask
endclass

module t;
  sub u_sub ();
  ifc u_ifc ();

  initial begin
    automatic Driver d = new;
    d.vif = u_ifc;
    #1;
    `checkh(u_sub.idx, 4'h1);
    d.run();
    #1;
    `checkh(u_sub.idx, 4'h7);
    `checkh(u_sub.tok, {{3{32'hcafe_f00d}}, 32'hcafe_f00f});
    release u_sub.idx;
    #1;
    `checkh(u_sub.idx, 4'h1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
