// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

`define EN_MASKING 0

// A bind in a generate block applies only if the block is elaborated (IEEE 1800-2023 23.11),
// and a block not elaborated may refer to what does not exist

module chk (
    input logic [3:0] v
);
endmodule

module dut #(
    parameter bit Masked = 0
) ();
  logic [3:0] plain = 4'h5;
  if (Masked) begin : gen_masks
    logic [3:0] state = 4'ha;
  end
endmodule

module binds;
  if (`EN_MASKING) begin : gen_masked
    bind dut chk u_masked (.v(gen_masks.state));
  end
  if (1) begin : gen_plain
    bind dut chk u_plain (.v(plain));
  end else begin : gen_other
    bind dut chk u_other (.v(gen_masks.state));
  end
endmodule

module t;
  dut u_dut ();
  binds u_binds ();
  if (`EN_MASKING) begin : gen_masked_check
    initial $display("%h", u_dut.u_masked.v);
  end
  initial begin
    #1;
    `checkh(u_dut.u_plain.v, 4'h5);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
