module sync_w2r #(
    parameter ADDR_WIDTH = 5
)(
    input logic [ADDR_WIDTH-1:0] wptr,
    input logic rclk, rrst_n,
    output logic [ADDR_WIDTH-1:0] rq2_wptr
);
    logic [ADDR_WIDTH-1:0] rq1_wptr;

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) {rq2_wptr, rq1_wptr} <= 0;
        else {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
    end
endmodule

