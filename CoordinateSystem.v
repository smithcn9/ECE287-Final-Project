module CoordinateSystem(
	input clk, //Clock signal
	input rst, //Reset signal
	output reg [9:0] x, //X coordinate (10 bits to represent 0-799)
	output reg [9:0] y // Y coordinate (10 bits to represent 0-599)
);

//Resolution constants to keep organized

localparam xMax = 800;
localparam yMax = 600;

//counters
reg [9:0] xCount = 0;
reg [9:0] yCount = 0;

//Update the counters based on the clock
always @(posedge clk) begin
	if (rst == 1'b1) begin
		//reset counters to 0 on reset
		xCount <= 0;
		yCount <= 0;
	end else begin
		//increase horizontal counter
		if (xCount < xMax - 1) begin
			xCount <= xCount + 1;
		end else begin
			// if we reached this point, horizontal reached its max. reset horizontal, and increase vertical by 1
			xCount <= 0;
			if (yCount < yMax - 1) begin
				yCount <= yCount + 1;
			end else begin
				//reset vertical counter if it reached max
				yCount <= 0;
			end
		end
	end
	
	//update x and y coordinates
	x <= xCount;
	y <= yCount;
	
	end
	
	endmodule
	
	
		