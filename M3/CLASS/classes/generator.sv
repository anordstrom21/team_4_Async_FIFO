/*********************************************
//	Generator Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  @execute() - creates new tx, randomizes it
//  and then put the value into gen2driv mailbox
//
//	Alexander Maso
//	 
*********************************************/


class generator;

  transaction tx;
  mailbox gen2driv, gen2scb;
  int tx_count = 500;


 function new (mailbox gen2driv, mailbox gen2scb);
    this.gen2driv = gen2driv;
    this.gen2scb = gen2scb;
  endfunction


  task execute();
    $display("********** Generator Started **********"); 
    repeat(tx_count) begin
      tx = new();
      assert(tx.randomize());
      gen2driv.put(tx);
      gen2scb.put(tx);
      $display("Generator tx  |  wr_en: %b  |  data: %h  ", tx.wr_en, tx.data_in); 
    end
    $display("********** Generator Ended **********"); 

  endtask : execute

endclass