/*********************************************
//	Driver Class for a UVM Based Testbench 
//  of an Asynchronous FIFO Module
//
//
//	Author: Alexander Maso
//	 
*********************************************/

class fifo_driver extends uvm_driver #(fifo_transaction); 
  `uvm_component_utils(fifo_driver)

  virtual fifo_bfm bfm;
  fifo_transaction tx;
  
  // Constructor
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), $sformatf("Constructing %s", get_full_name()), UVM_HIGH);
  endfunction : new

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase); 
    `uvm_info(get_type_name(), $sformatf("Building %s", get_full_name()), UVM_HIGH);
    
    if(!uvm_config_db #(virtual fifo_bfm)::get(this, "", "bfm", bfm))
      `uvm_fatal("NOBFM", {"bfm not defined for ", get_full_name(), "."});
  
  endfunction : build_phase

  // Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  
    `uvm_info(get_type_name(), $sformatf("Connecting %s", get_full_name()), UVM_HIGH);
  endfunction : connect_phase
  
  // Run Phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  //Not included in Doulos Video
    forever begin
      seq_item_port.get_next_item(tx); 
      // Drive data to FIFO
      if (tx.wr_en) begin
        @(posedge bfm.clk_wr);
          bfm.data_in   <= tx.data_in; 
          bfm.wr_en     <= tx.wr_en; 
      end
      if (tx.rd_en) begin
        @(posedge bfm.clk_rd);
          tx.rd_en    <= bfm.rd_en; 
      end 
      
      `uvm_info(get_type_name(), $sformatf("Driver tx \t\t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h  |  full: %b  |  empty: %b  |  half: %b", tx.wr_en, tx.rd_en, tx.data_in, tx.data_out, tx.full, tx.empty, tx.half), UVM_DEBUG);
      seq_item_port.item_done(); 
    end
  endtask : run_phase

/*
  task execute();
    $display("********** Driver Started **********");
    bfm.reset_fifo();  // reset takes 2 RD_CLKs
    repeat(TX_COUNT_WR) begin
      gen2drv.get(tx);
      // Drive data to FIFO
      @(posedge bfm.clk_wr);
        bfm.data_in <= tx.data_in; 
        bfm.wr_en   <= tx.wr_en; 
      // Update flags in this transaction
      @(negedge bfm.clk_wr); 
        tx.full      = bfm.full;
        tx.empty     = bfm.empty;
        tx.half      = bfm.half;
        $display("Driver tx \t\t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h  |  full: %b  |  empty: %b  |  half: %b", tx.wr_en, tx.rd_en, tx.data_in, tx.data_out, tx.full, tx.empty, tx.half);
        drv2scb.put(tx);
    end
    $display("********** Driver Ended **********");
  endtask : execute
*/  

endclass
