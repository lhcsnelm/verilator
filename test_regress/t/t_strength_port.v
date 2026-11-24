// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Drivers of a net in submodules resolve with their own strength against the other drivers

interface weak_if (
    inout wire p
);
  bit en = 0;
  logic val = 0;
  assign (weak0, weak1) p = en ? val : 1'bz;
endinterface

interface mixed_if (
    inout wire p
);
  bit strong_en = 0;
  bit weak_en = 0;
  assign p = strong_en ? 1'b0 : 1'bz;
  assign (weak0, weak1) p = weak_en ? 1'b1 : 1'bz;
endinterface

module pull_leaf (
    inout wire p,
    input en
);
  assign (weak0, pull1) p = en ? 1'b1 : 1'bz;
endmodule

module pull_mid (
    inout wire p,
    input en
);
  pull_leaf u_leaf (
      .p(p),
      .en(en)
  );
endmodule

module t;
  wire p;
  logic strong_en = 0;
  logic pull_en = 0;
  weak_if x (.p(p));
  weak_if y (.p(p));
  mixed_if m (.p(p));
  pull_mid u_mid (
      .p(p),
      .en(pull_en)
  );
  assign (strong0, strong1) p = strong_en ? 1'b0 : 1'bz;

  initial begin
    x.val = 1;
    x.en = 1;
    #1 `checkh(p, 1'b1);
    strong_en = 1;
    #1 `checkh(p, 1'b0);  // Strong over a weak interface driver
    strong_en = 0;
    x.en = 0;
    y.val = 1;
    y.en = 1;
    #1 `checkh(p, 1'b1);  // Weak driver of another instance
    y.val = 0;
    pull_en = 1;
    #1 `checkh(p, 1'b1);  // Pull from two levels down over weak
    m.strong_en = 1;
    #1 `checkh(p, 1'b0);  // Strong over pull, both from submodules
    m.strong_en = 0;
    pull_en = 0;
    y.en = 0;
    m.weak_en = 1;
    #1 `checkh(p, 1'b1);
    strong_en = 1;
    #1 `checkh(p, 1'b0);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
