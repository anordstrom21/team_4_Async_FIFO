module sync #(
    parameter ADDR_WIDTH = 7
)(
    input  logic             clk, rst_n,
    input  logic [ADDR_WIDTH-1:0] data_in,
    output logic [ADDR_WIDTH-1:0] data_out
);

    logic [ADDR_WIDTH-1:0] buffer;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            buffer <= 0;
        end else begin
            buffer <= data_in;
            data_out <= buffer;
        end
    end

endmodule
