/*********************************************
//	Driver Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//
//	Author: Alexander Maso
//	 
*********************************************/

class driver extends uvm_driver; // May need to add tx parameter...replace mbox?
  `uvm_component_utils(driver)

  virtual fifo_bfm bfm;
  mailbox gen2drv, drv2scb;
  transaction tx_wr;
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Build Phase
  function void build_phase(uvm_phase phase);
    //super.build_phase(phase);  Not included in Doulos Video
    if(!uvm_config_db #(virtual fifo_bfm)::get(this, "", "bfm", bfm))
      `uvm_fatal("NOBFM", {"bfm not defined for ", get_full_name(), "."});
  endfunction : build_phase
  
  // Run Phase
  task run_phase(uvm_phase phase);
    //super.run_phase(phase);  Not included in Doulos Video
    forever begin
      seq_item_port.get_next_item(tx); 
      execute();
      seq_item_port.item_done(); 
    end
  endtask : run_phase
/*
  function new(virtual fifo_bfm bfm, mailbox gen2drv, mailbox drv2scb);
    this.bfm = bfm;
    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
  endfunction
*/

  task execute();
    $display("********** Driver Started **********");
    bfm.reset_fifo();  // reset takes 2 RD_CLKs
    repeat(TX_COUNT_WR) begin
      gen2drv.get(tx_wr);
      // Drive data to FIFO
      @(posedge bfm.clk_wr);
        bfm.data_in <= tx_wr.data_in; 
        bfm.wr_en   <= tx_wr.wr_en; 
      // Update flags in this transaction
      @(negedge bfm.clk_wr); 
        tx_wr.full      = bfm.full;
        tx_wr.empty     = bfm.empty;
        tx_wr.half      = bfm.half;
        $display("Driver tx_wr \t\t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h  |  full: %b  |  empty: %b  |  half: %b", tx_wr.wr_en, tx_wr.rd_en, tx_wr.data_in, tx_wr.data_out, tx_wr.full, tx_wr.empty, tx_wr.half);
        drv2scb.put(tx_wr);
    end
    $display("********** Driver Ended **********");
  endtask : execute
  
/*  
  task execute();
    // Generate random data and write to FIFO
    forever begin
      bfm.data_in = $random;
      bfm.wr_en = 1;
      @(negedge bfm.clk_wr);
      bfm.wr_en = 0;
      repeat(10) @(negedge bfm.clk_wr);
    end
  endtask : execute
*/

endclass
