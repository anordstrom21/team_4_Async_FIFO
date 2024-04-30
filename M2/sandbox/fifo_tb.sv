module top;

  // Parameters for FIFO configuration
  parameter DATA_WIDTH = 8, ADDR_WIDTH = 6;
  parameter CYCLE_TIME_WR = 12.5;  // 80 MHz
  parameter CYCLE_TIME_RD = 20;    // 50 MHz

  // Testbench Signals
  logic clk_wr, clk_rd, rst_n;
  logic wr_en, rd_en;
  logic [DATA_WIDTH-1:0] data_in, data_out;
  logic full, empty;

  // Instantiate the FIFO
  fifo_top #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
  ) dut (
    .clk_wr(clk_wr),
    .clk_rd(clk_rd),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock Generation for Write and Read domains
  always #(CYCLE_TIME_WR/2) clk_wr = ~clk_wr;
  always #(CYCLE_TIME_RD/2) clk_rd = ~clk_rd;

  // Scoreboard
  // NOTE: 1<<ADDR_WIDTH = 2 to the power of ADDR_WIDTH
  // NOTE: Recently working with macros employing similar syntax
  logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
  logic [ADDR_WIDTH-1:0] write_addr, read_addr;


  // Reset Generation and Initializing Clocks
  initial begin
	  clk_wr = '0;
	  clk_rd = '0;
    rst_n = 1'b0;
    @(negedge clk_wr);
    rst_n = 1'b1;
  end

  // Randomized Data Generator
  function [DATA_WIDTH-1:0] getdata();
    return $random;
  endfunction

/*
  // Tester - Single burst read and write
  initial begin
    write_addr = '0;
    read_addr = '0;
    wr_en = 1'b0;
    rd_en = 1'b0;
    repeat (10) @(posedge clk_wr);
    
    // Grab data, set write enable and write for 10 write cylces
    @(negedge clk_wr)
    data_in = getdata();
    wr_en = 1'b1;
    repeat (9) begin
      @(negedge clk_wr)
      data_in = getdata();
    end
    // After 10 cycles enable read and continue for 110 remaining writes in burst
    rd_en = 1'b1;
    repeat (110) begin
      @(negedge clk_wr)
      data_in = getdata();
    end
    // Wait for all reads to complete
    repeat (150) @(posedge clk_rd);
    wr_en = 1'b0;
    rd_en = 1'b0;
    repeat (10) @(posedge clk_rd);
    $finish;
  end
*/

// Truly random testing is proving difficult to confirm accuracy of result
  // Test Process
  initial begin
    write_addr = '0;
    read_addr = '0;
    wr_en = 0;
    rd_en = 0;
    repeat (10) @(posedge clk_wr);
    repeat (1000) begin
      data_in = getdata();
      @(negedge clk_wr)
      wr_en = $random;
      @(negedge clk_rd)
      rd_en = $random;
      @(posedge clk_wr);
      @(posedge clk_rd);
    end
    repeat (10) @(posedge clk_wr);
    $finish;
  end

  // Coverage and Scoreboard
  covergroup cg_fifo with function sample(bit wr_en, bit rd_en, bit full, bit empty);
    coverpoint wr_en;
    coverpoint rd_en;
    coverpoint full;
    coverpoint empty;
  endgroup

  always @(posedge clk_wr) begin
    if (wr_en && !full) begin
      memory[write_addr] = data_in;
      write_addr++;
    end
  end

  always @(posedge clk_rd) begin
    if ($past(rd_en) && !empty) begin
      if (data_out != memory[read_addr-1]) begin
        $error("Mismatch at read address %d and write address %d Output expected: %h, received: %h", read_addr, write_addr, memory[read_addr-1], data_out);
      end
      read_addr++;
    end
  end

  // Instantiate coverage
  cg_fifo cg;
  initial begin
    cg = new();
    forever begin
      @(negedge clk_wr);
      cg.sample(wr_en, rd_en, full, empty);
    end
  end

endmodule
