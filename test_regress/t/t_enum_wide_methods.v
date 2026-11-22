// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
`define checks(gotv,expv) do if ((gotv) != (expv)) begin $write("%%Error: %s:%0d:  got='%s' exp='%s'\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

// Methods of an enum wider than 64 bits

module t;
  typedef enum logic [159:0] {
    E01 = 160'h1,
    ELARGE = 160'h1234_4567_abcd_1234_4567_abcd,
    EHIGH = {32'hdead_beef, 128'h0}
  } my_t;

  my_t e;
  int i_cast;

  function automatic my_t get(my_t v);
    return v;
  endfunction

  initial begin
    e = E01;
    `checks(e.name, "E01");
    `checkh(e.next, ELARGE);
    `checkh(e.next(2), EHIGH);
    `checkh(e.next(3), E01);
    `checkh(e.prev, EHIGH);
    `checkh(e.prev(0), E01);
    e = EHIGH;
    `checkh(e.next, E01);
    `checkh(e.prev(2), E01);
    `checks(e.name, "EHIGH");
    // Of an expression evaluated once
    `checkh(get(ELARGE).next, EHIGH);
    // Validity
    i_cast = $cast(e, 160'h1234);
    `checkh(i_cast, 0);
    `checkh(e, EHIGH);
    i_cast = $cast(e, 160'h1234_4567_abcd_1234_4567_abcd);
    `checkh(i_cast, 1);
    `checkh(e, ELARGE);
    // Unknown
    e = my_t'('h11);
    `checks(e.name, "");
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
