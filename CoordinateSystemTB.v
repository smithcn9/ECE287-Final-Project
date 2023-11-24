`timescale 1ns / 1ps

module CoordinateSystemTB;

	reg clk;
	reg rst;

	wire [9:0] x;
	wire [9:0] y;

	CoordinateSystem uut (
    	.clk(clk),
    	.rst(rst),
    	.x(x),
    	.y(y)
	);

	initial begin
    	clk = 0;
    	forever #10 clk = ~clk;
	end

	initial begin
    	rst = 1;  
    	#100;    
    	rst = 0;  

    	#10000000; 

    	$stop;
	end

endmodule



