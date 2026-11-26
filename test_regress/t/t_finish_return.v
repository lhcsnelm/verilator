// DESCRIPTION: Verilator: Verilog Test module
//
// No statement runs after $finish: functions that may call it return at once, as do
// their callers, but final blocks still run to their end.
//
// This file ONLY is placed under the Creative Commons Public Domain.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: CC0-1.0

module t;
  int did_more = 0;
  int loops = 0;
  int final_steps = 0;

  class Reporter;
    virtual function void report(int n);
    endfunction
  endclass

  class Dying extends Reporter;
    virtual function void report(int n);
      if (n == 3) $finish;
    endfunction
  endclass

  class Checker;
    Reporter rep;
    function int check(int n);
      rep.report(n);
      ++did_more;  // Not after $finish
      return n;
    endfunction
    task run();
      #1;
      // Loops without suspending, as a checker whose expectation is never met
      do begin
        ++loops;
        void'(check(loops));
      end while (loops < 1000);
      ++did_more;
    endtask
  endclass

  function void final_report();
    ++final_steps;
    if (final_steps < 3) $finish;  // $finish again during final does not stop it
    ++final_steps;
  endfunction

  initial begin
    static Checker c = new;
    static Dying d = new;
    c.rep = d;
    c.run();
    ++did_more;
  end

  final begin
    final_report();
    final_report();
    if (loops != 3) $stop;
    if (did_more != 2) $stop;
    if (final_steps != 4) $stop;
    $write("*-* All Finished *-*\n");
  end
endmodule
