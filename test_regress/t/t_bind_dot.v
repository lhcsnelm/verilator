// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2013 by Ed Lander.
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

module t;

  int checks = 0;  // Instances of mycheck

  bind u_a1.u_b1 mycheck #(.CHECK('h11)) u_check ();
  bind u_a1.u_b2 mycheck #(.CHECK('h12)) u_check ();
  bind u_a2.u_b1 mycheck #(.CHECK('h21)) u_check ();
  bind u_a2.u_b2 mycheck #(.CHECK('h22)) u_check ();
  // Paths from the top module, and through generate blocks
  bind t.u_a1.gen_if.u_c mycheck #(.CHECK('h31)) u_check ();
  bind u_a2.gen_else.u_c mycheck #(.CHECK('h32)) u_check ();
  bind u_a2.gen_case.u_c mycheck #(.CHECK('h33)) u_check ();
  // Instance without a dot, connected in the scope of the instance
  bind u_d portcheck #(.CHECK(VAL)) u_check (.in(sig));
  // Module binds also apply to instances made unique for the binds above
  bind modb mycheck #(.CHECK('h99)) u_all ();

  moda #(.VAL('h10)) u_a1 ();
  moda #(.VAL('h20)) u_a2 ();
  modd #(.VAL('h40)) u_d ();

  initial begin
    `checkh(u_a1.u_b1.u_check.CHECK, 'h11);
    `checkh(u_a1.u_b2.u_check.CHECK, 'h12);
    `checkh(u_a2.u_b1.u_check.CHECK, 'h21);
    `checkh(u_a2.u_b2.u_check.CHECK, 'h22);
    `checkh(u_a1.gen_if.u_c.u_check.CHECK, 'h31);
    `checkh(u_a2.gen_else.u_c.u_check.CHECK, 'h32);
    `checkh(u_a2.gen_case.u_c.u_check.CHECK, 'h33);
    `checkh(u_d.u_check.CHECK, 'h40);
    `checkh(u_d.u_check.in, 1'b1);
    `checkh(u_a1.u_b1.u_all.CHECK, 'h99);
    `checkh(u_a2.u_b2.u_all.CHECK, 'h99);
    $write("*-* All Finished *-*\n");
    $finish;
  end

  // No instances other than those targeted
  final `checkh(checks, 14);

endmodule

module moda;
  parameter VAL = 0;
  modb #(.VAL(VAL + 1)) u_b1 ();
  modb #(.VAL(VAL + 2)) u_b2 ();
  if (VAL == 'h10) begin : gen_if
    modb u_c ();
  end else begin : gen_else
    modb u_c ();
  end
  case (VAL)
    'h20: begin : gen_case
      modb u_c ();
    end
    default: ;
  endcase
endmodule

module modb;
  parameter VAL = 0;
endmodule

module modd;
  parameter VAL = 0;
  wire sig = 1'b1;
endmodule

module mycheck;
  parameter CHECK = 0;
  initial t.checks++;
endmodule

module portcheck (
    input in
);
  parameter CHECK = 0;
endmodule
