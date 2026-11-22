// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkh(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got='h%x exp='h%x\n", `__FILE__,`__LINE__, (gotv), (expv)); `stop; end while(0);
// verilog_format: on

class Item;
  logic [7:0] data[$];
  typedef bit [7:0] data_t[];
  function data_t get_data();
    data_t ret = data;
    return ret;
  endfunction
endclass

module t;

  logic [7:0] lq[$];
  bit [7:0] bd[];
  bit [7:0] bq[$];

  initial begin
    automatic Item item = new;
    lq = '{8'h12, 8'h34, 8'h56};
    // Arrays of elements differing only in 2-state and 4-state, as other simulators allow
    bd = lq;
    `checkh(bd.size(), 3);
    `checkh(bd[2], 8'h56);
    bq = {8'h9a, 8'hbc};
    item.data = bq;
    `checkh(item.data.size(), 2);
    `checkh(item.data[0], 8'h9a);
    bd = item.get_data();
    `checkh(bd.size(), 2);
    `checkh(bd[1], 8'hbc);
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
