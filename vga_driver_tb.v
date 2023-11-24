`timescale 1ns / 1ps

module vga_driver_tb;

    reg clk;
    reg rst;
    reg [7:0] red;
    reg [7:0] green;
    reg [7:0] blue;

    wire vga_h_sync;
    wire vga_v_sync;
    wire [7:0] vga_red;
    wire [7:0] vga_green;
    wire [7:0] vga_blue;

    vga_driver uut (
        .clk(clk), 
        .rst(rst), 
        .red(red), 
        .green(green), 
        .blue(blue), 
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );

    wire [9:0] xCoord, yCoord;

    CoordinateSystem coordSys(
        .clk(clk),
        .rst(rst),
        .x(xCoord),
        .y(yCoord)
    );

    initial begin
        clk = 0;
        forever #20 clk = ~clk; 
    end

    initial begin
        rst = 1;
        red = 0;
        green = 0;
        blue = 0;

        #100;
        rst = 0; 

        red = 8'hFF;
        #400000;
        red = 8'h00;

        green = 8'hFF;
        #400000;
        green = 8'h00;

        blue = 8'hFF;
        #400000;
        blue = 8'h00;

        #100000000;
        $finish;
    end
      
endmodule
