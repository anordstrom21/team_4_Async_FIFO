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

    function new (virtual fifo_bfm b);
        bfm = b;
    endfunction : new


    // Adding this paramters just to check functionality of the environment
    // FIXME: I believe this should be imported as part of the package but Questa won't allow it
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 6;
    parameter DEPTH = 2**ADDR_WIDTH;
  
    // Local memory, ptrs and count used to check FIFO
    logic [DATA_WIDTH-1:0] memory[DEPTH-1:0]; 
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

    task shift();
        @(posedge bfm.clk_rd) begin
            if (bfm.rd_en && !bfm.empty) begin
                data_last <= memory[read_ptr];
                rd_en_last <= bfm.rd_en;
            end
        end
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
  
    task read_and_check();
        if (count > 0) begin
            logic [DATA_WIDTH-1:0] expected_data = memory[read_ptr];
            // If rd_en wasn't asserted last cycle then read_addr points to data
            if (!rd_en_last) begin
                if (bfm.data_out != expected_data) begin
                    $error("Data mismatch!: expected %h, got %h at read pointer %0d", expected_data, bfm.data_out, read_ptr);
                end
            end
            // If rd_en was asserted last cycle then data will be one cycle behind
            else begin
                if (bfm.data_out != data_last) begin
                    $error("Data mismatch!: expected %h, got %h at read pointer %0d", expected_data, bfm.data_out, read_ptr);
                end
            end
            read_ptr = (read_ptr + 1) % DEPTH; //Modulo keeps values in range from 0 to DEPTH-1
            count--;
        end else begin
            $display("Scoreboard Error: Read from empty FIFO attempted.");
        end
  endtask : read_and_check

  // Monitor both write and read operations to keep the scoreboard fifo updated
  task execute();
    forever begin
      @(negedge bfm.clk_wr);
      if (bfm.wr_en && !bfm.full) write(bfm.data_in);
      
      @(posedge bfm.clk_rd);
      if (bfm.rd_en && !bfm.empty) read_and_check();
    end
  endtask : execute   
   
endclass : scoreboard