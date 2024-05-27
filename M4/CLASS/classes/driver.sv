/*********************************************
//	Driver Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//
//	Author: Alexander Maso
//	 
*********************************************/

class driver;
  virtual fifo_bfm bfm;
  mailbox gen2drv, drv2scb;
  transaction tx_wr;

  function new(virtual fifo_bfm bfm, mailbox gen2drv, mailbox drv2scb);
    this.bfm = bfm;
    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
  endfunction


  task execute();
    $display("********** Driver Started **********");
    bfm.reset_fifo();  // reset takes 2 RD_CLKs
    repeat(TX_COUNT_WR) begin
      gen2drv.get(tx_wr);
      @(posedge bfm.clk_wr);
        $display("Driver tx_wr \t\t|  wr_en: %b  |  rd_en: %b  |  data_in: %h  |  data_out: %h", tx_wr.wr_en, tx_wr.rd_en, tx_wr.data_in, tx_wr.data_out);
        bfm.data_in <= tx_wr.wr_en ? tx_wr.data_in : bfm.data_in; // if wr_en is high, drive data_in to FIFO
        bfm.wr_en   <= tx_wr.wr_en; // drive wr_en to FIFO
        // bfm.rd_en   <= tx_wr.rd_en; // drive rd_en to FIFO
        // udpdate flags in this transaction
        tx_wr.full      = bfm.full;
        tx_wr.empty     = bfm.empty;
        tx_wr.half      = bfm.half;
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
