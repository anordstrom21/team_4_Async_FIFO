/***************************************************************
*  Coverage class for a UVM Based FIFO Verification
* 
*
*  Author: Alexander Maso
***************************************************************/

class fifo_coverage extends uvm_subscriber #(fifo_transaction);
    `uvm_component_utils(fifo_coverage) // Register the component with the factory

    // Declare the handle for our transactions
    fifo_transaction tx;

    // real is a double precision floating-point variable
    // For coverage numbers/printing (.get_coverage() returns a value of type real)

    real cov_cg_fifo;
    real cov_cg_fifo_depth;
    real cov_cg_data_range;
    real cov_cg_data_patterns;
    real cov_cg_abrupt_change;


    // Define covergroups
    // Covergroup for basic FIFO signals
    covergroup cg_fifo;
	option.per_instance = 1;
	coverpoint tx.clk_wr {
	    bins clock_write_high = {1};
	    bins clock_write_low = {0};
	}
	coverpoint tx.clk_rd {
	    bins clock_read_high = {1};
	    bins clock_read_low = {0};
	}
        coverpoint tx.wr_en {
            bins wr_en_high = {1};
            bins wr_en_low = {0};
        }
        coverpoint tx.rd_en {
            bins rd_en_high = {1};
            bins rd_en_low = {0};
        }
        coverpoint tx.full {
            bins full_true = {1};
            bins full_false = {0};
        }
        coverpoint tx.empty {
            bins empty_true = {1};
            bins empty_false = {0};
        }
        coverpoint tx.half {
            bins half_full_true = {1};
            bins half_full_false = {0};
        }
    endgroup

    // Covergroup for depth levels of  FIFO
/*
    covergroup cg_fifo_depth;
	option.per_instance = 1;
        coverpoint tx.wptr {
            bins low = {[0:15]};            // Low depth
            bins mid = {[16:31]};           // Mid depth
            bins high = {[32:47]};          // High depth
            bins max = {[48:63]};           // Max depth
        }
        coverpoint tx.rptr {
            bins low = {[0:15]};            // Low depth
            bins mid = {[16:31]};           // Mid depth
            bins high = {[32:47]};          // High depth
            bins max = {[48:63]};           // Max depth 
        }
    endgroup
*/

    // Covergroup for data integrity
    covergroup cg_data_range;
	option.per_instance = 1;
        coverpoint tx.data_out {
            bins data_low = {[0:63]};
            bins data_mid = {[64:127]};
            bins data_high = {[128:191]};
            bins data_max = {[192:255]};
        }
    endgroup

    // Covergroup for specific data patterns
    covergroup cg_data_patterns;
	option.per_instance = 1;
        coverpoint tx.data_in {
            bins pattern_zero = {8'h00};
            bins pattern_all_ones = {8'hFF};
            bins pattern_alt_ones = {8'h55, 8'hAA};
        }
        coverpoint tx.data_out {
            bins pattern_zero = {8'h00};
            bins pattern_all_ones = {8'hFF};
            bins pattern_alt_ones = {8'h55, 8'hAA};
        }
    endgroup


    // Covergroup for capturing abrupt changes in r/w rates
    covergroup cg_abrupt_change;
	coverpoint tx.clk_wr {
            bins clk_wr_high_to_low = (1 => 0);
            bins clk_wr_low_to_high = (0 => 1);
        }
        coverpoint tx.clk_rd {
            bins clk_rd_high_to_low = (1 => 0);
            bins clk_rd_low_to_high = (0 => 1);
        }
        coverpoint tx.wr_en {
            bins wr_en_high_to_low = (1 => 0);
            bins wr_en_low_to_high = (0 => 1);
        }
        coverpoint tx.rd_en {
            bins rd_en_high_to_low = (1 => 0);
            bins rd_en_low_to_high = (0 => 1);
        }
	coverpoint tx.full {
            bins full_high_to_low = (1 => 0);
            bins full_low_to_high = (0 => 1);
        }
	coverpoint tx.half {
            bins half_high_to_low = (1 => 0);
            bins half_low_to_high = (0 => 1);
        }
	coverpoint tx.empty {
            bins empty_high_to_low = (1 => 0);
            bins empty_low_to_high = (0 => 1);
        }
    endgroup


    // Constructor
    function new(string name = "fifo_coverage", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info(get_type_name(), $sformatf("Constructing %s", get_full_name()), UVM_DEBUG);
    
        tx = fifo_transaction::type_id::create("tx");
	cg_fifo = new();
	//cg_fifo_depth = new();
	cg_data_range = new();
	cg_data_patterns = new();
	cg_abrupt_change = new();
    endfunction : new

    virtual function void write(fifo_transaction t);
        `uvm_info(get_type_name(), $sformatf("Writing to %s", get_full_name()), UVM_DEBUG);
        tx = t;
        t.print();

	cg_fifo.sample();
	//cg_fifo_depth.sample();
	cg_data_range.sample();
	cg_data_patterns.sample();
	cg_abrupt_change.sample();


	cov_cg_fifo = cg_fifo.get_coverage();
    	//cov_cg_fifo_depth = cg_fifo_depth.get_coverage();
    	cov_cg_data_range = cg_data_range.get_coverage();
    	cov_cg_data_patterns = cg_data_patterns.get_coverage();
    	cov_cg_abrupt_change = cg_abrupt_change.get_coverage();

/*
        `uvm_info(get_type_name(), $sformatf("Coverage cg_fifo: %f", cov_cg_fifo), UVM_NONE);
	    //`uvm_info(get_type_name(), $sformatf("Coverage cg_fifo_depth: %f", cov_cg_fifo_depth), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Coverage cg_data_range: %f", cov_cg_data_range), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Coverage cg_data_patterns: %f", cov_cg_data_patterns), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Coverage cg_idle_cycles: %f", cov_cg_idle_cycles), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Coverage cg_abrupt_change: %f", cov_cg_abrupt_change), UVM_NONE);
*/

    endfunction : write

endclass

