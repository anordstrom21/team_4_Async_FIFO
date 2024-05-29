class fifo_sequence extends uvm_sequence #(fifo_transaction);
  
  `uvm_object_utils(fifo_sequence)
  
  // Constructor 
  function new(string name="fifo_sequence");
    super.new(name);
  endfunction
  
  // virtual task body();
  // Not virtual in Doulos Video
  task body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);

    // generate some transactions
    tx_wr = fifo_transaction::type_id::create("tx");
    repeat(TX_COUNT_WR) begin
      start_item(tx_wr);
      
      if (!tx_wr.randomize())
        `uvm_error("RANDOMIZE", "Failed to randomize transaction")
      
      tx_wr.wr_en = 1;
      tx_wr.rd_en = 0;
      `uvm_info("GENERATE", tx.convert2string(), UVM_MEDIUM)
      finish_item(tx);
    end

    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask : body
  
endclass