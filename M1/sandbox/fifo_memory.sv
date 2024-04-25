module fifo_memory #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6
)(
    input  logic                      clk_wr, clk_rd,
    input  logic                      wr_en, rd_en,
    input  logic  [ADDR_WIDTH-1:0]    waddr, raddr,
    input  logic  [DATA_WIDTH-1:0]    data_in,
    output logic  [DATA_WIDTH-1:0]    data_out

);
    
    logic [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0];

    always_ff @(posedge clk_wr) begin
        if (wr_en) mem[waddr] <= data_in;
    end

    always_ff @(posedge clk_rd) begin
        if (rd_en) data_out <= mem[raddr];
    end

endmodule
