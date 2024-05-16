class transaction;
	localparam DATA_WIDTH = 8;	//Can't import a package into a class

	//random inputs
	rand logic wr_en;
	rand logic rd_en;
	rand logic [DATA_WIDTH-1:0] data_in;

	//outputs
	logic [DATA_WIDTH-1:0] data_out;
	logic full;
	logic half;
	logic empty;

	constraint wr_con{wr_en dist {1 := 3, 0 := 1};}	//3x more likely to write than not
	constraint rd_con{rd_en dist {1 := 1, 0 := 2};}	//2x more likely to not read than read

	/*
	function void print();
		$display("Writing: %b or Reading: %b", wr_en, rd_en);
		$display("Data in: %h, Data out: %h", data_in, data_out);
		$display("Full: %b, Half: %b, Empty: %b", full, half, empty);
	endfunction: print
	*/

endclass: transaction
