module sync #(
    parameter ADDR_WIDTH = 6
)(
    input  logic             clk, rst_n,
    input  logic [ADDR_WIDTH:0] data_in,
    output logic [ADDR_WIDTH:0] data_out
);

    logic [ADDR_WIDTH:0] buffer;
    logic [ADDR_WIDTH:0] buffer2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            buffer <= 0;
            buffer2 <= 0;
        end else begin
            buffer <= data_in;
            buffer2 <= buffer;
            data_out <= buffer2;
        end
    end

endmodule
