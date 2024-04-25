module read_pointer #(
    parameter ADDR_WIDTH = 6
)(
    input  logic                    clk, rst_n, inc,
    input  logic [ADDR_WIDTH:0]     rq2_wptr,
    output logic [ADDR_WIDTH:0]     rptr,
    output logic [ADDR_WIDTH-1:0]   raddr,
    output logic                    empty
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rptr <= 0;
        else if (inc && !empty)
            rptr <= rptr + 1;
    end

    always_ff @(posedge clk) begin
        empty <= (rptr[ADDR_WIDTH-1:0] == rq2_wptr[ADDR_WIDTH-1:0]) && (rptr[ADDR_WIDTH] == rq2_wptr[ADDR_WIDTH]);
    end

    assign raddr = rptr[ADDR_WIDTH-1:0];

endmodule
