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

  rand transaction tx;
  mailbox gen2driv;
  int tx_count=1;

  extern function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction

  task execute();
    $display("Generator started"); 
    repeat(tx_count) begin
      tx = new();
      assert (tx.randomize());
      gen2driv.put(tx);
    end

  endtask : execute

endclass