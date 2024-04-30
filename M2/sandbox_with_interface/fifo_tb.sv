module top;

  // Parameters for FIFO configuration
  parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
  parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
  parameter CYCLE_TIME_RD = 20;    // 50 MHz

  //Instantiating the interface
	Asynchronous_FIFO_bfm bfm();

  // Instantiate the FIFO
  fifo_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .clk_wr(bfm.clk_wr),
    .clk_rd(bfm.clk_rd),
    .rst_n(bfm.rst_n),
    .wr_en(bfm.wr_en),
    .rd_en(bfm.rd_en),
    .data_in(bfm.data_in),
    .data_out(bfm.data_out),
    .full(bfm.full),
    .empty(bfm.empty)
  );

  // Clock Generation for Write and Read domains
  always #(CYCLE_TIME_WR/2) bfm.clk_wr = ~bfm.clk_wr;
  always #(CYCLE_TIME_RD/2) bfm.clk_rd = ~bfm.clk_rd;

  // Scoreboard
  // NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
  // NOTE: Recently working with macros employing similar syntax
  logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
  logic [ADDR_WIDTH-1:0] write_addr, read_addr;


  // Reset Generation and Initializing Clocks
  initial begin
	  bfm.clk_wr = '0;
	  bfm.clk_rd = '0;
    bfm.rst_n = 1'b0;
    @(negedge bfm.clk_wr);
    bfm.rst_n = 1'b1;
  end

  // Randomized Data Generator
  function [DATA_WIDTH-1:0] getdata();
    return $random;
  endfunction


  // Tester - Single burst read and write
  initial begin
    write_addr = '0;
    read_addr = '0;
    bfm.wr_en = 1'b0;
    bfm.rd_en = 1'b0;
    repeat (10) @(posedge bfm.clk_wr);
    
    // Grab data, set write enable and write for 10 write cylces
    @(negedge bfm.clk_wr)
    bfm.data_in = getdata();
    bfm.wr_en = 1'b1;
    repeat (9) begin
      @(negedge bfm.clk_wr)
      bfm.data_in = getdata();
    end
    // After 10 cycles enable read and continue for 110 remaining writes in burst
    bfm.rd_en = 1'b1;
    repeat (110) begin
      @(negedge bfm.clk_wr)
      bfm.data_in = getdata();
    end
    // Wait for all reads to complete
    repeat (150) @(posedge bfm.clk_rd);
    bfm.wr_en = 1'b0;
    bfm.rd_en = 1'b0;
    repeat (10) @(posedge bfm.clk_rd);
    $finish;
  end


/* Truly random testing is proving difficult to confirm accuracy of result
Trying simpler, burst style testbench to help with debug

  // Test Process
  initial begin
    bfm.wr_en = 0;
    bfm.rd_en = 0;
    repeat (10) @(posedge bfm.clk_wr);
    repeat (1000) begin
      bfm.data_in = getdata();
      @(negedge bfm.clk_wr)
      bfm.wr_en = $random;
      @(negedge bfm.clk_rd)
      bfm.rd_en = $random;
      @(posedge bfm.clk_wr);
      @(posedge bfm.clk_rd);
    end
    repeat (10) @(posedge bfm.clk_wr);
    $finish;
  end
*/

  // Coverage and Scoreboard
  covergroup cg_fifo with function sample(bit wr_en, bit rd_en, bit full, bit empty);
    coverpoint wr_en;
    coverpoint rd_en;
    coverpoint full;
    coverpoint empty;
  endgroup

  always @(posedge bfm.clk_wr) begin
    if (bfm.wr_en && !bfm.full) begin
      memory[write_addr] = bfm.data_in;
      write_addr++;
    end
  end

  always @(posedge bfm.clk_rd) begin
    if (bfm.rd_en && !bfm.empty) begin
      if (bfm.data_out != memory[read_addr-1]) begin
        $display("Mismatch at address %d: expected %h, got %h", read_addr, memory[read_addr-1], bfm.data_out);
      end
      read_addr++;
    end
  end

  // Instantiate coverage
  cg_fifo cg;
  initial begin
    cg = new();
    forever begin
      @(negedge bfm.clk_wr);
      cg.sample(bfm.wr_en, bfm.rd_en, bfm.full, bfm.empty);
    end
  end

endmodule
