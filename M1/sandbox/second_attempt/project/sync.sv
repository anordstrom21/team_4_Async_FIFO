module sync #(
    parameter ADDR_WIDTH = 6
)(
    input  logic             clk, rst_n,
    input  logic [ADDR_WIDTH:0] data_in,
    output logic [ADDR_WIDTH:0] data_out
);

    logic [ADDR_WIDTH:0] buffer;
    logic [ADDR_WIDTH:0] buffer2;
    logic [ADDR_WIDTH:0] buffer3;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
            buffer <= 0;
            buffer2 <= 0;
            buffer3 <= 0;
        end else begin
            buffer <= data_in;
            buffer2 <= buffer;
            buffer3 <= buffer2;
            buffer4 <= buffer3;
        end
    end

endmodule
