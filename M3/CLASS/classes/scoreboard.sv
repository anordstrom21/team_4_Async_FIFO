/*********************************************
//	Scoreboard Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  Creates virtual bfm and calls constructor
//  Contains functions shift(), write() and read_and_check()
//  and task execute().  
//
//  @ shift() saves the past value of rd_eb and the data word that
//  read_ptr points to in the local fifo
//  @ write() creates a local fifo and writes data_in to the fifo.  
//  @ read_and_check()reads from the local fifo and compares it 
//  against data_out of the bfm.  
//  @ execute() runs the write() and the read_and_check() functions indefinitely
//
//
//	Alexander Maso
//	 
*********************************************/

class scoreboard;
    
    virtual fifo_bfm bfm;
    mailbox mon2scb;
    mailbox gen2scb;
    transaction tx_rd, tx_wr;
    int tx_count = 1000;

    function new (virtual fifo_bfm bfm, mailbox mon2scb, mailbox gen2scb);
        this.bfm = bfm;
        this.mon2scb = mon2scb;
        this.gen2scb = gen2scb;
    endfunction : new

    // Local memory, ptrs and count used to check FIFO
    localparam DEPTH = 2**ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1]; 
    int write_ptr = 0;
    int read_ptr = 0;
    int count = 0;

    // If rd_en was asserted last cycle then the value 
    // read_ptr of tester points to the last value on 
    // bfm.data_out, not the current one.  These signals
    // stores past value of data_out and rd_en for comparison
    // (Essentially the dut's read pointer is slower)
    logic [DATA_WIDTH-1:0] data_last;
    logic  rd_en_last;

    task shift(input logic [DATA_WIDTH-1:0] data, input logic rd_en);
                data_last <= data;
                rd_en_last <= rd_en;
    endtask : shift
   
    task write(input logic [DATA_WIDTH-1:0] data);
        if (count < DEPTH) begin
            memory[write_ptr] = data;
            write_ptr = (write_ptr + 1) % DEPTH; //Modulo keeps values in range from 0 to DEPTH-1
            count++;
        end else begin
            $display("Scoreboard Error: Write to full FIFO attempted.");
        end
     endtask : write
  
    task read_and_check(input logic [DATA_WIDTH-1:0] data);
        if (count > 0) begin
            logic [DATA_WIDTH-1:0] expected_data = memory[read_ptr];
            // If rd_en wasn't asserted last cycle then read_addr points to data
            if (!rd_en_last) begin
                if (data != expected_data) begin
                    $error("Data mismatch!: expected %h, got %h at read pointer %0d", expected_data, data, read_ptr);
                end
            end
            // If rd_en was asserted last cycle then data will be one cycle behind
            else begin
                if (data != data_last) begin
                    $error("Data mismatch!: expected %h, got %h at read pointer %0d", expected_data, data, read_ptr);
                end
            end
            read_ptr = (read_ptr + 1) % DEPTH; //Modulo keeps values in range from 0 to DEPTH-1
            count--;
        end else begin
            //$display("Scoreboard Error: Read from empty FIFO attempted.");
        end
  endtask : read_and_check

  // Monitor both write and read operations to keep the scoreboard fifo updated
  task execute();
    #(CYCLE_TIME_RD*15+1);
    $display("********** Scoreboard Started **********"); 
    //forever begin
    repeat(tx_count) begin
      tx_wr = new();
      gen2scb.get(tx_wr);
      @(posedge bfm.clk_wr);
      if (tx_wr.wr_en && !bfm.full) write(tx_wr.data_in);

      tx_rd = new(); 
      mon2scb.get(tx_rd);
      $display("Scoreboard tx | rd_en: %b | Data: %h", tx_rd.rd_en, tx_rd.data_out);
      @(posedge bfm.clk_rd);
      shift(tx_rd.data_out, tx_rd.rd_en);
      if (tx_rd.rd_en && !bfm.empty) begin
        read_and_check(tx_rd.data_out);
      end
    end
    $display("********** Scoreboard Ended **********"); 
    $finish();
  endtask : execute   
   
endclass 