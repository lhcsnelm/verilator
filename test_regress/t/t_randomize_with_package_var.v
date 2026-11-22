// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

package p;
  typedef struct {
    bit [31:0] start_addr;
    bit [31:0] end_addr;
  } range_t;
  typedef struct {
    string name;
    range_t ranges[$];
  } device_t;
  device_t devices[$] = '{'{"a", '{'{32'h1000, 32'h1fff}, '{32'h3000, 32'h3fff}}}};
  int unsigned min_delay = 2;
endpackage

class Item;
  rand bit [31:0] addr;
  rand int unsigned delay;
endclass

class Seq;
  int range_id = 1;
  // Package variables read by a randomize() with from a class method
  function bit randomize_req(Item req, bit mapped);
    return bit'(req.randomize() with {
      delay inside {[p::min_delay : p::min_delay + 1]};
      if (mapped) {
        addr inside {[p::devices[0].ranges[range_id].start_addr :
                       p::devices[0].ranges[range_id].end_addr]};
      } else {
        foreach (p::devices[0].ranges[i]) {
          !(addr inside {[p::devices[0].ranges[i].start_addr : p::devices[0].ranges[i].end_addr]});
        }
      }
    });
  endfunction
endclass

module t;

  initial begin
    automatic Item req = new;
    automatic Seq s = new;
    repeat (10) begin
      if (!s.randomize_req(req, 1)) $stop;
      if (req.addr < 32'h3000 || req.addr > 32'h3fff) $stop;
      if (req.delay < 2 || req.delay > 3) $stop;
      if (!s.randomize_req(req, 0)) $stop;
      if (req.addr inside {[32'h1000 : 32'h1fff], [32'h3000 : 32'h3fff]}) $stop;
    end
    $write("*-* All Finished *-*\n");
    $finish;
  end

endmodule
