module image_processor(
    input clk,
    input rst,
    output vga_h_sync,
    output vga_v_sync,
    output [7:0] vga_red,
    output [7:0] vga_green,
    output [7:0] vga_blue
);


    wire [10:0] xCoord, yCoord;
    wire [7:0] red, green, blue;

    CoordinateSystem coordSys(
        .clk(clk),
        .rst(rst),
        .x(xCoord),
        .y(yCoord)
    );

	 radial_image_generator gen(
			.clk(clk),
			.rst(rst),
			.xCoord(xCoord),
			.yCoord(yCoord),
			.red(red),
			.green(green),
			.blue(blue)
	 
	 );
	 
    vga_driver vgaDriver(
        .clk(clk),
        .rst(rst),
		  .xCoord(xCoord),
		  .yCoord(yCoord),
        .red(red),
        .green(green),
        .blue(blue),
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue)
    );

endmodule
