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
//
//	Alexander Maso
//	 
*********************************************/

class testbench;
  
  virtual fifo_bfm bfm;
  mailbox gen2driv, gen2scb, mon2scb;

  //tester      tester_h;
  coverage    coverage_h;
  scoreboard  scoreboard_h;
  monitor     monitor_h;
  driver      driver_h;
  generator   generator_h;

  function new (virtual fifo_bfm bfm, mailbox gen2driv, mailbox gen2scb, mailbox mon2dcb);
    this.bfm = bfm;
    this.gen2driv = gen2driv;
    this.gen2scb = gen2scb;
    this.mon2scb = mon2scb;
  endfunction : new

  task execute();
   
//    tester_h    = new(bfm);
    gen2driv = new();
    gen2scb = new();
    mon2scb = new();
    coverage_h   = new(bfm);
    scoreboard_h = new(bfm, mon2scb, gen2scb);
    monitor_h = new(bfm, mon2scb);
    driver_h = new(bfm, gen2driv);
    generator_h = new(gen2driv, gen2scb);

    fork
//      tester_h.execute();
      coverage_h.execute();
      scoreboard_h.execute();
      monitor_h.execute();
      driver_h.execute();
      generator_h.execute();
    join_none

   endtask : execute

endclass
