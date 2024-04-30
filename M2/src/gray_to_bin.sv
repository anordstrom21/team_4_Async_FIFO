module gray_to_bin #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6
)(
    input logic     [ADDR_WIDTH:0] gray,
    output logic    [ADDR_WIDTH:0] binary
);

    // For each bit position, loop performs reduction XOR on all bits from MSB to given position
    // Gray Code to Binary Conversion
    always_comb begin
        for (int i=0; i<=ADDR_WIDTH; i++) begin
            binary[i] = ^(gray >> i);
        end
    end

endmodule