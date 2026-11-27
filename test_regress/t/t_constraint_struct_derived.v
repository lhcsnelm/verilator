// DESCRIPTION: Verilator: Verilog Test module
//
// Classes derived from the same base each constrain members of an inherited
// struct, which all of them must register with the solver.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

typedef enum bit [1:0] {
  E0,
  E1,
  E2,
  E3
} e_t;

typedef struct {
  rand e_t mode;
  rand e_t dir;
  rand bit [3:0] len;
} s_t;

class Base;
  rand s_t s;
  rand int x;
  constraint x_c {x inside {[1 : 5]};}
endclass

class Mid extends Base;
endclass

class First extends Mid;
  constraint s_c {
    s.dir == E3;
    s.mode == E1;
  }
endclass

class Second extends Base;
  constraint s_c {
    s.dir == E2;
    s.len == 4'd9;
  }
endclass

module t;
  initial begin
    First first;
    Second second;
    int ok;
    first = new;
    second = new;
    ok = second.randomize();
    `checkd(ok, 1);
    `checkd(second.s.dir, E2);
    `checkd(second.s.len, 9);
    ok = first.randomize();
    `checkd(ok, 1);
    `checkd(first.s.dir, E3);
    `checkd(first.s.mode, E1);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
