module write_control #(
    parameter ADDR_WIDTH = 9  // Extra bit to differentiate full vs empty
)(
    input logic wclk, wrst_n, winc,
    output logic wfull,
    output logic [ADDR_WIDTH-1:0] wptr,
    output logic [ADDR_WIDTH-2:0] waddr
);
    logic [ADDR_WIDTH-1:0] wptr_next, rptr_sync;

    // Pointer update logic
    assign wptr_next = wptr + (winc && !wfull);
    assign waddr = wptr[ADDR_WIDTH-2:0];

    // Full logic assuming wrap-around check
    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wptr <= 0;
            wfull <= 1'b0;
        end else begin
            wptr <= wptr_next;
            wfull <= (wptr_next[ADDR_WIDTH-2:0] == rptr_sync[ADDR_WIDTH-2:0]) &&
                     (wptr_next[ADDR_WIDTH-1] != rptr_sync[ADDR_WIDTH-1]);
        end
    end

    // Instationation for synchronization from read domain
    sync_r2w #(.ADDR_WIDTH(ADDR_WIDTH)) sync_r2w_inst (.rptr(rptr_sync), .wclk(wclk), .wrst_n(wrst_n), .wq2_rptr(wptr));
endmodule
