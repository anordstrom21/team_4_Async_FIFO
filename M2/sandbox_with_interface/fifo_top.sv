module fifo_top #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6  // Log2 of FIFO depth 64
)(
    input  logic                   clk_wr, clk_rd, rst_n,
    input  logic                   wr_en, rd_en,
    input  logic [DATA_WIDTH-1:0]  data_in,
    output logic [DATA_WIDTH-1:0]  data_out,
    output logic                   full, empty
);
	//Instantiating the interface
	Asynchronous_FIFO_bfm bfm();

    // Memory
    fifo_memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem_inst (
        .clk_wr(bfm.clk_wr),
        .clk_rd(bfm.clk_rd),
        .waddr(bfm.waddr),
        .raddr(bfm.raddr),
        .data_in(bfm.data_in),
        .data_out(bfm.data_out),
        .wr_en(bfm.wr_en & ~bfm.full),
        .rd_en(bfm.rd_en & ~bfm.empty)
    );

    // Write Pointer Logic
    write_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) write_ptr (
        .clk(bfm.clk_wr),
        .rst_n(bfm.rst_n),
        .inc(bfm.wr_en & ~bfm.full),
        .wptr(bfm.wptr),
        .waddr(bfm.waddr),
        .wq2_rptr(bfm.wq2_rptr),
        .full(bfm.full)
    );

    // Read Pointer Logic
    read_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) read_ptr (
        .clk(bfm.clk_rd),
        .rst_n(bfm.rst_n),
        .inc(bfm.rd_en & ~bfm.empty),
        .rptr(bfm.rptr),
        .raddr(bfm.raddr),
        .rq2_wptr(bfm.rq2_wptr),
        .empty(bfm.empty)
    );

    // Synchronization from write to read domain
    sync #(.ADDR_WIDTH(ADDR_WIDTH)) sync_w2r (
        .clk(bfm.clk_rd),
        .rst_n(bfm.rst_n),
        .data_in(bfm.wptr),
        .data_out(bfm.rq2_wptr)
    );

    // Synchronization from read to write domain
    sync #(.ADDR_WIDTH(ADDR_WIDTH)) sync_r2w (
        .clk(bfm.clk_wr),
        .rst_n(bfm.rst_n),
        .data_in(bfm.rptr),
        .data_out(bfm.wq2_rptr)
    );

endmodule

