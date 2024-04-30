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
    logic [ADDR_WIDTH-1:0] waddr, raddr;
    logic [ADDR_WIDTH:0] wptr, rptr;
    logic [ADDR_WIDTH:0] gray_wptr, gray_rptr;
    logic [ADDR_WIDTH:0] wq2_rptr, rq2_wptr;
    logic [ADDR_WIDTH:0] gray_wq2_rptr, gray_rq2_wptr;

    // Memory
    fifo_memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem_inst (
        .clk_wr(clk_wr),
        .clk_rd(clk_rd),
        .waddr(waddr),
        .raddr(raddr),
        .data_in(data_in),
        .data_out(data_out),
        .wr_en(wr_en & ~full),
        .rd_en(rd_en & ~empty)
    );

    // Write Pointer Logic
    write_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) write_ptr (
        .clk(clk_wr),
        .rst_n(rst_n),
        .inc(wr_en & ~full),
        .wptr(wptr),
        .waddr(waddr),
        .wq2_rptr(wq2_rptr),
        .full(full)
    );

    // Read Pointer Logic
    read_pointer #(.ADDR_WIDTH(ADDR_WIDTH)) read_ptr (
        .clk(clk_rd),
        .rst_n(rst_n),
        .inc(rd_en & ~empty),
        .rptr(rptr),
        .raddr(raddr),
        .rq2_wptr(rq2_wptr),
        .empty(empty)
    );

    // Binary to gray conversion in read domain
    bin_to_gray #(.ADDR_WIDTH(ADDR_WIDTH)) b2g_rptr (
        .binary(rptr),
        .gray(gray_rptr)
    );

    // Binary to gray conversion in write domain
    bin_to_gray #(.ADDR_WIDTH(ADDR_WIDTH)) b2g_wptr (
        .binary(wptr),
        .gray(gray_wptr)
    );

    // Gray code to binary conversion in the read domain
    gray_to_bin #(.ADDR_WIDTH(ADDR_WIDTH)) g2b_rptr (
        .gray(gray_wq2_rptr),
        .binary(wq2_rptr)
    );

    // Gray code to binary conversion in the write domain
    gray_to_bin #(.ADDR_WIDTH(ADDR_WIDTH)) g2b_wptr (
        .gray(gray_rq2_wptr),
        .binary(rq2_wptr)
    );

    // Synchronization from write to read domain
    sync #(.ADDR_WIDTH(ADDR_WIDTH)) sync_w2r (
        .clk(clk_rd),
        .rst_n(rst_n),
        .data_in(gray_wptr),
        .data_out(gray_rq2_wptr)
    );

    // Synchronization from read to write domain
    sync #(.ADDR_WIDTH(ADDR_WIDTH)) sync_r2w (
        .clk(clk_wr),
        .rst_n(rst_n),
        .data_in(gray_rptr),
        .data_out(gray_wq2_rptr)
    );
       
endmodule      
       
       
       
       
       
       