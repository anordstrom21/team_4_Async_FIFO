class fifo_sequence extends uvm_sequence #(transaction);
  
  `uvm_object_utils(fifo_sequence)
  
  // Define your sequence variables here
  
  function new(string name);
    super.new(name);
  endfunction
  
  // virtual task body();
  // Not virtual in Doulos Video
  task body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);

    // generate some transactions
    repeat(10) begin
        tx = transaction::type_id::create("tx");
        start_item(tx);

        if (!tx.randomize())
          `uvm_error("RANDOMIZE", "Failed to randomize transaction")

        finish_item(tx);
    end


    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask : body
  
endclass