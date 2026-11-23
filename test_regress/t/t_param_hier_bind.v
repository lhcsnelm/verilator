// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// A parameter value of a parameter of an instance below, by its hierarchical name, as other
// simulators allow, is of the instance as specialized

module pad #(
    parameter bit EnMasking = 1'b1
);
endmodule

module sha3 #(
    parameter bit EnMasking = 1'b0
);
  pad #(.EnMasking(EnMasking)) u_pad ();
endmodule

module kmac #(
    parameter bit EnMasking = 1'b1
);
  sha3 #(.EnMasking(!EnMasking)) u_sha3 ();
endmodule

interface chk_if #(
    parameter bit EnMasking = 1'b0,
    parameter bit Exp = 1'b0
);
  initial begin
    if (EnMasking !== Exp) begin
      $write("%%Error: %m EnMasking=%0d exp=%0d\n", EnMasking, Exp);
      $stop;
    end
  end
endinterface

module t;
  kmac #(.EnMasking(1'b1)) dut ();
  kmac #(.EnMasking(1'b0)) dut2 ();

  bind kmac chk_if #(.EnMasking(u_sha3.u_pad.EnMasking), .Exp(!EnMasking)) u_chk ();

  initial begin
    #1;
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
