`timescale 1ns / 1ps

module CoordinateSystemTB;

	// Inputs to the CoordinateSystem module
	reg clk;
	reg rst;

	// Outputs from the CoordinateSystem module
	wire [9:0] x;
	wire [9:0] y;

	// Instantiate the CoordinateSystem module
	CoordinateSystem uut (
    	.clk(clk),
    	.rst(rst),
    	.x(x),
    	.y(y)
	);

	// Clock generation
	initial begin
    	clk = 0;
    	forever #10 clk = ~clk; // Clock with a period of 20ns (50MHz)
	end

	// Test procedure
	initial begin
    	// Initialize Inputs
    	rst = 1;   	// Assert reset
    	#100;      	// Wait for 100ns
    	rst = 0;   	// Deassert reset

    	// Wait long enough to observe behavior
    	#10000000;   	// Wait for 200,000ns (200us), adjust as needed

    	// End simulation
    	$stop;
	end

endmodule



