`timescale 1ns/1ps

module tb_async_fifo();

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 9;

    // Clocks
    logic wclk, rclk;

    // Resets
    logic wrst_n, rrst_n;

    // Control Signals
    logic write_enable, read_enable;

    // Data Signals
    logic [DATA_WIDTH-1:0] data_in, data_out;

    // FIFO Status Signals
    logic fifo_full, fifo_empty;

    // Instantiate the FIFO
    async_fifo_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .wclk(wclk),
        .rclk(rclk),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_in(data_in),
        .data_out(data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    // Clock generation
    initial begin
        wclk = 0;
        forever #6.25 wclk = ~wclk;  // 80 MHz
    end

    initial begin
        rclk = 0;
        forever #10 rclk = ~rclk;  // 50 MHz
    end

    // Reset Logic
    initial begin
        wrst_n = 0; rrst_n = 0;
        #100 wrst_n = 1; rrst_n = 1;  // Release reset after 100 ns
    end

    // Test sequence
    initial begin
        write_enable = 0;
        read_enable = 0;
        data_in = 0;

        // Wait for reset deassertion
        @(posedge wrst_n);
        @(posedge rrst_n);
        #50;  // Wait 50 ns for the system to stabilize

        // Begin write operations
        repeat (120) begin
            @(posedge wclk);
            if (!fifo_full) begin
                write_enable = 1;
                data_in = $random;
            end else begin
                write_enable = 0;
            end
        end

        // Stop write operations
        write_enable = 0;

        // Begin read operations
        repeat (120) begin
            @(posedge rclk);
            if (!fifo_empty) begin
                read_enable = 1;
            end else begin
                read_enable = 0;
            end
        end

        // Stop read operations
        read_enable = 0;

        // Complete simulation
        #500;
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time=%t, WR=%b, RD=%b, DataIn=%h, DataOut=%h, Full=%b, Empty=%b",
                 $time, write_enable, read_enable, data_in, data_out, fifo_full, fifo_empty);
    end

endmodule
