/****************************************
*  Transaction Class for the OOP/Class Based
*  Testbench for an Asynchronous FIFO Module
*
*  This class contains the transaction packet
*  that is passed between the generator, driver,
*  monitor, and scoreboard.  It contains inputs
*  that can be randomized as well as containers
*  for the outputs and flags of the FIFO module.
*  
*  Author: Nick Alleyer
*  Modifications: Alexander Maso
****************************************/

class transaction extends uvm_sequence_item;
	`uvm_object_utils(transaction)	//provides type name for factory creation

	function new(string name = "transaction");
		super.new(name);
	endfunction: new

	// inputs
	rand logic wr_en;
	rand logic rd_en;
	rand logic [DATA_WIDTH-1:0] data_in;

	// outputs
	logic [DATA_WIDTH-1:0] data_out;
	logic full;
	logic half;
	logic empty;

	//constraint wr_con{wr_en dist {1 := 3, 0 := 1};}	//3x more likely to write than not
	//constraint rd_con{rd_en dist {1 := 1, 0 := 2};}	//2x more likely to not read than read

	/*
	function void print();
		$display("Writing: %b or Reading: %b", wr_en, rd_en);
		$display("Data in: %h, Data out: %h", data_in, data_out);
		$display("Full: %b, Half: %b, Empty: %b", full, half, empty);
	endfunction: print
	*/

	function string convert2string();
		return $sformatf("Writing: %b or Reading: %b\nData in: %h, Data out: %h\nFull: %b, Half: %b, Empty: %b", wr_en, rd_en, data_in, data_out, full, half, empty);
	endfunction: convert2string

	function void do_copy(uvm_object rhs);
		transaction tx;
		if (!$cast(tx, rhs))
			`uvm_fatal("COPY", "Object not of transaction type")
		wr_en = tx.wr_en;
		rd_en = tx.rd_en;
		data_in = tx.data_in;
		data_out = tx.data_out;
		full = tx.full;
		half = tx.half;
		empty = tx.empty;
	endfunction: do_copy

	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		transaction tx;
		if (!$cast(tx, rhs))
			`uvm_fatal("COMPARE", "Object not of transaction type")
		if (wr_en !== tx.wr_en)
			return 0;
		if (rd_en !== tx.rd_en)
			return 0;
		if (data_in !== tx.data_in)
			return 0;
		if (data_out !== tx.data_out)
			return 0;
		if (full !== tx.full)
			return 0;
		if (half !== tx.half)
			return 0;
		if (empty !== tx.empty)
			return 0;
		return 1;
	endfunction: do_compare

endclass: transaction
