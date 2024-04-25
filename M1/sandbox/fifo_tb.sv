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

  // Test Process
  initial begin
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

  // Scoreboard for checking data integrity
  logic [DATA_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
  logic [ADDR_WIDTH:0] write_ptr = 0, read_ptr = 0;

  always @(posedge clk_wr) begin
    if (wr_en && !full) begin
      memory[write_ptr[ADDR_WIDTH-1:0]] = data_in;
      write_ptr++;
    end
  end

  always @(posedge clk_rd) begin
    if (rd_en && !empty) begin
      if (data_out !== memory[read_ptr[ADDR_WIDTH-1:0]-1]) begin
        $display("Mismatch at %d: expected %h, got %h", read_ptr, memory[read_ptr[ADDR_WIDTH-1:0]-1], data_out);
      end
      read_ptr++;
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
