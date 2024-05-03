module write_pointer #(
    parameter ADDR_WIDTH = 6
)(
    input  logic                    clk, rst_n, inc,
    input  logic [ADDR_WIDTH:0]     wq2_rptr,
    output logic [ADDR_WIDTH:0]     wptr,
    output logic [ADDR_WIDTH-1:0]   waddr,
    output logic                    full
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wptr <= 0;
        else if (inc && !full)
            wptr <= wptr + 1;
    end

    always_ff @(posedge clk) begin
        full <= (wptr[ADDR_WIDTH-1:0] == wq2_rptr[ADDR_WIDTH-1:0]) && (wptr[ADDR_WIDTH] != wq2_rptr[ADDR_WIDTH]);
    end

    assign waddr = wptr[ADDR_WIDTH-1:0];
    
endmodule

