/*
Interface for the Asynchronous FIFO
*/

interface Asynchronous_FIFO_bfm_ext;

//Importing package with parameter definitions
import Asynchronous_FIFO_pkg::*;

//External FIFO signals
logic clk_wr; 
logic clk_rd; 
logic rst_n;
logic wr_en;
logic rd_en;
logic [DATA_WIDTH-1:0] data_in;
logic [DATA_WIDTH-1:0] data_out;
logic full;
logic empty;

//Generating both free running clocks
initial
begin
	clk_rd = '0;
	clk_wr = '0;
	forever
	begin
		#(CYCLE_TIME_WR/2) clk_wr = ~clk_wr;
		#(CYCLE_TIME_RD/2) clk_rd = ~clk_rd;
	end
end

//Task to reset the FIFO
task reset_FIFO();
    rst_n = '0;
    @(negedge clk_wr);
    rst_n = '1;
endtask

endinterface



interface Asynchronous_FIFO_bfm_int;

//Importing package with parameter definitions
import Asynchronous_FIFO_pkg::*;

//Internal FIFO signals
logic [ADDR_WIDTH:0] wptr;
logic [ADDR_WIDTH:0] rptr;
logic [ADDR_WIDTH-1:0] waddr;
logic [ADDR_WIDTH-1:0] raddr;
logic [ADDR_WIDTH:0] wq2_rptr;
logic [ADDR_WIDTH:0] rq2_wptr;


endinterface




//Modports aren't really necessary here
/*
modport mem_unit_signals(	input clk_wr, 
							input clk_rd,
							input wr_en,
							input rd_en,
							input waddr, 
							input raddr,
							input data_in
							output data_out);


modport read_ptr_signals(	input clk_rd,
							input rst_n,
							input rd_en,
							input rq2_wptr,
							output rptr,
							output raddr,
							output empty);

modport write_ptr_signals(	input clk_wr,
							input rst_n,
							input wr_en,
							input wq2_rptr,
							output wptr,
							output waddr,
							output full);

modport rd2wr_signals(	input clk_wr,
						input rst_n,
						input rptr,
						output wq2_rptr);

modport wr2rd_signals(	input clk_rd,
						input rst_n,
						input wptr,
						output rq2_wptr);
*/



