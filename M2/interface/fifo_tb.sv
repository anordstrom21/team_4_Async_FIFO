module top;

  // Parameters for FIFO configuration
  parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
  parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
  parameter CYCLE_TIME_RD = 20;    // 50 MHz

  //Instantiating the interface
  Asynchronous_FIFO_bfm_ext bfm_ext();

  // Instantiate the FIFO
  fifo_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .clk_wr(bfm_ext.clk_wr),
    .clk_rd(bfm_ext.clk_rd),
    .rst_n(bfm_ext.rst_n),
    .wr_en(bfm_ext.wr_en),
    .rd_en(bfm_ext.rd_en),
    .data_in(bfm_ext.data_in),
    .data_out(bfm_ext.data_out),
    .full(bfm_ext.full),
    .empty(bfm_ext.empty)
  );

  // Clock Generation for Write and Read domains
  always #(CYCLE_TIME_WR/2) bfm_ext.clk_wr = ~bfm_ext.clk_wr;
  always #(CYCLE_TIME_RD/2) bfm_ext.clk_rd = ~bfm_ext.clk_rd;

  // Scoreboard
  // NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
  // NOTE: Recently working with macros employing similar syntax
  logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
  logic [ADDR_WIDTH-1:0] write_addr, read_addr;


  // Reset Generation and Initializing Clocks
  initial begin
	  bfm_ext.clk_wr = '0;
	  bfm_ext.clk_rd = '0;
    bfm_ext.rst_n = 1'b0;
    @(negedge bfm_ext.clk_wr);
    bfm_ext.rst_n = 1'b1;
  end

  // Randomized Data Generator
  function [DATA_WIDTH-1:0] getdata();
    return $random;
  endfunction


  // Tester - Single burst read and write
  initial begin
    write_addr = '0;
    read_addr = '0;
    bfm_ext.wr_en = 1'b0;
    bfm_ext.rd_en = 1'b0;
    repeat (10) @(posedge bfm_ext.clk_wr);
    
    // Run through 25 randomized 120 word bursts. 
    repeat (25) begin
      // Grab data, set write enable and write for 10 write cylces
      @(negedge bfm_ext.clk_wr)
      bfm_ext.data_in = getdata();
      bfm_ext.wr_en = 1'b1;
      repeat (9) begin
        @(negedge bfm_ext.clk_wr)
        bfm_ext.data_in = getdata();
      end

      // After 10 cycles enable read and continue for 110 remaining writes in burst
      bfm_ext.rd_en = 1'b1;
      repeat (110) begin
        @(negedge bfm_ext.clk_wr)
        bfm_ext.data_in = getdata();
      end
    
      // After 120 cycles of wr_clk -> Deassert wr_en
      bfm_ext.wr_en = 1'b0;
      // Wait for all reads to complete
      repeat (150) @(posedge bfm_ext.clk_rd);
      bfm_ext.rd_en = 1'b0;
      repeat (50) @(posedge bfm_ext.clk_rd);
    end

/*
    // Reset TB FIFO and then preform 1000 cycle fully randomized test 
    write_addr = '0;
    read_addr = '0;
    bfm_ext.wr_en = 0;
    bfm_ext.rd_en = 0;
    repeat (10) @(posedge bfm_ext.clk_wr);
    repeat (1000) begin
      bfm_ext.data_in = getdata();
      @(negedge bfm_ext.clk_wr)
      bfm_ext.wr_en = $random;
      @(negedge bfm_ext.clk_rd)
      bfm_ext.rd_en = $random;
      @(posedge bfm_ext.clk_wr);
      @(posedge bfm_ext.clk_rd);
    end
    repeat (50) @(posedge bfm_ext.clk_wr);
*/

  $stop();
  end

  // Coverage and Scoreboard
  covergroup cg_fifo with function sample(bit wr_en, bit rd_en, bit full, bit empty);
    coverpoint wr_en;
    coverpoint rd_en;
    coverpoint full;
    coverpoint empty;
  endgroup

  always @(posedge bfm_ext.clk_wr) begin
    if (bfm_ext.wr_en && !bfm_ext.full) begin
      memory[write_addr] = bfm_ext.data_in;
      write_addr++;
    end
  end

  always @(posedge bfm_ext.clk_rd) begin
    if (bfm_ext.rd_en && !bfm_ext.empty) begin
      if (bfm_ext.data_out != memory[$past(read_addr, 1, bfm_ext.clk_rd)]) begin
        $error("Mismatch at address %d: expected %h, got %h", read_addr, memory[$past(read_addr, 1, bfm_ext.clk_rd)], bfm_ext.data_out);
      end
      else begin
        $display("Match at address %d: expected %h, got %h", read_addr, memory[$past(read_addr, 1, bfm_ext.clk_rd)], bfm_ext.data_out);
      end
      read_addr++;
    end
  end

  // Instantiate coverage
  cg_fifo cg;
  initial begin
    cg = new();
    forever begin
      @(negedge bfm_ext.clk_wr);
      cg.sample(bfm_ext.wr_en, bfm_ext.rd_en, bfm_ext.full, bfm_ext.empty);
    end
  end

endmodule
