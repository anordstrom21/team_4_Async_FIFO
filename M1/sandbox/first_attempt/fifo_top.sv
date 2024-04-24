module async_fifo_top #(
    parameter DATA_WIDTH = 8,  // Data width of FIFO data bus
    parameter ADDR_WIDTH = 9   // Address width (including the extra bit for full/empty distinction)
)(
    input logic wclk,            // Write clock
    input logic rclk,            // Read clock
    input logic wrst_n,          // Write domain reset, active low
    input logic rrst_n,          // Read domain reset, active low
    input logic write_enable,    // Write enable signal
    input logic read_enable,     // Read enable signal
    input logic [DATA_WIDTH-1:0] data_in,  // Data input
    output logic [DATA_WIDTH-1:0] data_out, // Data output
    output logic fifo_full,       // FIFO full flag
    output logic fifo_empty       // FIFO empty flag
);

    // Internal signals for address and data connections
    logic [ADDR_WIDTH-2:0] waddr, raddr;
    logic [ADDR_WIDTH-1:0] wptr, rptr;
    logic wclken, rclken;

    // FIFO Memory Module
    fifo_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) fifo_mem_inst (
        .wdata(data_in),
        .rdata(data_out),
        .waddr(waddr),
        .raddr(raddr),
        .wclken(wclken),
        .rclken(rclken),
        .wclk(wclk),
        .rclk(rclk)
    );

    // Write Control Module
    write_control #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) write_ctrl_inst (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(write_enable),
        .wfull(fifo_full),
        .wptr(wptr),
        .waddr(waddr)
    );

    // Read Control Module
    read_control #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) read_ctrl_inst (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(read_enable),
        .rempty(fifo_empty),
        .rptr(rptr),
        .raddr(raddr)
    );

    // Enabling logic for memory writes and reads
    assign wclken = write_enable && !fifo_full;
    assign rclken = read_enable && !fifo_empty;

endmodule
