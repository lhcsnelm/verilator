// DESCRIPTION: Verilator: Verilog Test module
//
// std::randomize resizes a dynamic array or queue to a size constraint.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

// verilog_format: off
`define stop $stop
`define checkd(gotv,expv) do if ((gotv) !== (expv)) begin $write("%%Error: %s:%0d:  got=%0d exp=%0d (%s !== %s)\n", `__FILE__,`__LINE__, (gotv), (expv), `"gotv`", `"expv`"); `stop; end while(0);
// verilog_format: on

class Cls;
  int unsigned num_bytes = 6;

  task test_queue();
    bit [7:0] data[$];
    int ok;
    bit [7:0] all_or;
    ok = std::randomize(data) with {data.size == num_bytes;};
    `checkd(ok, 1);
    `checkd(data.size(), 6);
    // The new elements are random too
    all_or = 0;
    repeat (4) begin
      ok = std::randomize(data) with {data.size == num_bytes;};
      `checkd(ok, 1);
      foreach (data[i]) all_or |= data[i];
    end
    `checkd(all_or != 0, 1);
  endtask

  task test_dyn();
    int unsigned total = 10;
    int count = 3;
    int unsigned lens[];
    int ok;
    int unsigned sum;
    ok = std::randomize(lens) with {
      lens.size() == count;
      lens.sum() == total;
      foreach (lens[i]) lens[i] inside {[1 : total]};
      lens[count - 1] > 2;
    };
    `checkd(ok, 1);
    `checkd(lens.size(), 3);
    sum = 0;
    foreach (lens[i]) sum += lens[i];
    `checkd(sum, 10);
    `checkd(lens[2] > 2, 1);
  endtask
endclass

module t;
  initial begin
    Cls c;
    int q[$];
    int ok;
    c = new;
    c.test_queue();
    c.test_dyn();
    ok = std::randomize(q) with {
      q.size() inside {[2 : 3]};
      foreach (q[i]) q[i] == i + 7;
    };
    `checkd(ok, 1);
    `checkd(q.size() inside {[2 : 3]}, 1);
    `checkd(q[0], 7);
    `checkd(q[1], 8);
    // A failing size constraint leaves the queue as it was
    ok = std::randomize(q) with {
      q.size() == 2;
      q.size() == 3;
    };
    `checkd(ok, 0);
    `checkd(q[0], 7);
    $write("*-* All Finished *-*\n");
    $finish;
  end
endmodule
