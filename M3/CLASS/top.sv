/*********************************************
//	Top Module for the OOP/Class Based Testbench
//  of an Asynchronous FIFO Module
//	Contains instantaion of the bfm and connection
//  to the dut.  Also creates a new handle for the
//  testbench class, passes the constructor the bfm
//  and calls the execute() function 
//
//	Alexander Maso
//	 
*********************************************/
module top;
  import   fifo_pkg::*;
   
   // Instantiate the dut and connect it with the Bus Func Model
   fifo_top dut (.clk_wr(bfm.clk_wr), .clk_rd(bfm.clk_rd), .rst_n(bfm.rst_n), 
                 .wr_en(bfm.wr_en), .rd_en(bfm.rd_en), .data_in(bfm.data_in),
                 .data_out(bfm.data_out), .full(bfm.full), .empty(bfm.empty), 
                 .half(bfm.half));

   fifo_bfm     bfm();

   testbench    testbench_h;

   initial begin
      testbench_h = new(bfm);
      testbench_h.execute();
   end
   
endmodule : top