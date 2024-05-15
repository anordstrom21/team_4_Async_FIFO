/*********************************************
//	Scoreboard Class for the OOP/Class Based 
//  Testbench for an Asynchronous FIFO Module
//
//  Creates virtual bfm and calls constructor
//  Contains functions, write() and read_and_check()
//  and task execute().  Write() creates a local fifo
//  and write data_in to the fifo.  Read_and_check()
//  reads from the local fifo and compares it again
//  data_out of the bfm.  Execute() runs the write()
//  and the read_and_check() functions indefinitely
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
            if (bfm.data_out !== expected_data) begin
                $error("Data mismatch!: expected %h, got %h at read pointer %0d", expected_data, bfm.data_out, read_ptr);
            end
            /*else begin
                $display("Scoreboard: Data out %h, matches expected %h at read pointer %0d", bfm.data_out, expected_data, read_ptr);
            end*/
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