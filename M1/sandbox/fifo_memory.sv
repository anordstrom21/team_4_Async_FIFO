module fifo_memory #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8  // Adjust based on the burst size and FIFO depth
)(
    input logic [DATA_WIDTH-1:0] wdata,
    input logic [ADDR_WIDTH-1:0] waddr, raddr,
    input logic wclken, rclken,
    input logic wclk, rclk,
    output logic [DATA_WIDTH-1:0] rdata
);
    logic [DATA_WIDTH-1:0] mem [(1<<ADDR_WIDTH)-1:0];

    // Write operation
    always_ff @(posedge wclk) begin
        if (wclken) mem[waddr] <= wdata;
    end

    // Read operation
    always_ff @(posedge rclk) begin
        if (rclken) rdata <= mem[raddr];
    end
endmodule
