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
  mailbox gen2driv;
  int tx_count=120;


 function new (mailbox g2d);
    gen2driv = g2d;
  endfunction


  task execute();
    $display("Generator started"); 
    repeat(tx_count) begin
      tx = new();
      assert(tx.randomize());
      gen2driv.put(tx);
      $display("generator tx data: %h  wr_en: %b", tx.data_in, tx.wr_en); 
    end

  endtask : execute

endclass