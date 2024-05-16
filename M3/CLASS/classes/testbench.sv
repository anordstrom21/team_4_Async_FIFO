/*********************************************
//	Testbench Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  Creates virtual bfm and calls constructor
//  Also creates handles for tester, coverage
//  and scoreboard classes.  Contains task 
//  execute(), which passes the constructor for 
//  all handles above the bfm, then forks and
//  calls the execute() function for each.
//
//  NOTE: Unsure if I need to import the package here
//
//	Alexander Maso
//	 
*********************************************/

class testbench;
  
  virtual fifo_bfm bfm;

  tester      tester_h;
  coverage  coverage_h;
  scoreboard  scoreboard_h;
  monitor     monitor_h;
  driver      driver_h;

  function new (virtual fifo_bfm b);
    bfm = b;
  endfunction : new

  task execute();
    tester_h    = new(bfm);
    coverage_h   = new(bfm);
    scoreboard_h = new(bfm);
    monitor_h = new(bfm);
    driver_h = new(bfm);

    fork
      tester_h.execute();
      coverage_h.execute();
      scoreboard_h.execute();
      monitor_h.execute();
      driver_h.execute();
    join_none

   endtask : execute

endclass
