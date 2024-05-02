/*
Interface for the Asynchronous FIFO
*/

interface Asynchronous_FIFO_bfm;
	import Asynchronous_FIFO_pkg;

	logic clk_wr; 
	logic clk_rd; 
	logic rst_n;
	logic wr_en;
	logic rd_en;
	logic [DATA_WIDTH-1:0] data_in;
	logic [DATA_WIDTH-1:0] data_out;
	logic full;
	logic empty;
	logic [ADDR_WIDTH:0] wptr;
	logic [ADDR_WIDTH:0] rptr;
	logic [ADDR_WIDTH-1:0] waddr;
	logic [ADDR_WIDTH-1:0] raddr;
	logic [ADDR_WIDTH:0] wq2_rptr;
	logic [ADDR_WIDTH:0] rq2_wptr;

	// Scoreboard
  	// NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
  	// NOTE: Recently working with macros employing similar syntax
  	logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
  	logic [ADDR_WIDTH-1:0] write_addr, read_addr;

	// Initializing Clocks and Clock generator for Write and Read domains
	initial begin
		clk_wr = '0;
		clk_rd = '0;
		
		fork
			forever #(CYCLE_TIME_WR/2) clk_wr = ~clk_wr;
			forever #(CYCLE_TIME_RD/2) clk_rd = ~clk_rd;
		join
	end

	// Reset Generation
	initial begin
		rst_n = 1'b0;
		@(negedge clk_wr);
		rst_n = 1'b1;
	end


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



endinterface
