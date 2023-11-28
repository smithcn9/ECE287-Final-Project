`timescale 1ns / 1ps

module image_processor_tb;

    reg clk;
    reg rst;
    wire vga_h_sync;
    wire vga_v_sync;
    wire [7:0] vga_red;
    wire [7:0] vga_green;
    wire [7:0] vga_blue;

    // Instantiate the image_processor module
    image_processor uut (
        .clk(clk),
        .rst(rst),
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #20 clk = ~clk; // Generate a clock with a period of 40ns
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;

        // Wait for some time and then release reset
        #100;
        rst = 0;
		  
		  
        // You can add more test scenarios here if needed
        // For example, simulating user inputs, changing resolution, etc.

        // Run the simulation for a specified time
        #100000000;
        $finish;
    end

endmodule
