module bin_to_gray #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6
)(
    input logic     [ADDR_WIDTH:0] binary,
    output logic    [ADDR_WIDTH:0] gray
);

    // Shift vector left by 1 and XOR with original vector
    // Binary to Gray Code Conversion
    assign gray = (binary << 1) ^ binary;

endmodule