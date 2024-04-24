
module sync_r2w #(
    parameter ADDR_WIDTH = 5
)(
    input logic [ADDR_WIDTH-1:0] rptr,
    input logic wclk, wrst_n,
    output logic [ADDR_WIDTH-1:0] wq2_rptr
);
    logic [ADDR_WIDTH-1:0] wq1_rptr;

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) {wq2_rptr, wq1_rptr} <= 0;
        else {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
    end
endmodule