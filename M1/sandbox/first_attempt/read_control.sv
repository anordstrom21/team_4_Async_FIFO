module read_control #(
    parameter ADDR_WIDTH = 9
)(
    input logic rclk, rrst_n, rinc,
    output logic rempty,
    output logic [ADDR_WIDTH-1:0] rptr,
    output logic [ADDR_WIDTH-2:0] raddr
);
    logic [ADDR_WIDTH-1:0] rptr_next, wptr_sync;

    // Pointer update and empty logic
    assign rptr_next = rptr + (rinc && !rempty);
    assign raddr = rptr[ADDR_WIDTH-2:0];

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr <= 0;
            rempty <= 1'b1;
        end else begin
            rptr <= rptr_next;
            rempty <= (rptr_next == wptr_sync);
        end
    end

    // Instantiation for synchronization from write domain
    sync_w2r #(.ADDR_WIDTH(ADDR_WIDTH)) sync_w2r_inst (.wptr(wptr_sync), .rclk(rclk), .rrst_n(rrst_n), .rq2_wptr(rptr));

endmodule
