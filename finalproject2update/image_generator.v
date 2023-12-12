module image_generator(
	input rst, 
	input clk, 
	output reg VGA_clk, 
	output reg [7:0] VGA_R, 
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B, 
	output VGA_hSync, 
	output VGA_vSync, 
	output VGA_BLANK_N,
	input [5:0] switches
);
    
    wire [9:0] pixelColumn;
    wire [9:0] pixelRow;
    wire displayArea;
    
	 //clock divider
    always@(posedge clk) begin
		VGA_clk <= ~VGA_clk;
	 end
	 
    VGA_gen gen1(VGA_clk, pixelColumn, pixelRow, displayArea, VGA_hSync, VGA_vSync, VGA_BLANK_N);

	 parameter x_center = 640 / 2;
    parameter y_center = 480 / 2;
    
	 reg [7:0] centerRed, centerGreen, centerBlue; //inside color
    reg [7:0] outsideRed, outsideGreen, outsideBlue; //outside color
	 
	 reg [31:0] distance_squared, max_distance_squared;
	 
    always @(posedge VGA_clk) begin
		  max_distance_squared = ((x_center - 0) * (x_center - 0)) + ((y_center - 0) * (y_center - 0));
		  distance_squared = ((pixelColumn - x_center) * (pixelColumn - x_center)) + ((pixelRow - y_center) * (pixelRow - y_center));
		  
	     if (switches[0]) 
				centerRed <= 8'hFF;
        else 
				centerRed <= 8'h00;

        if (switches[1]) 
				centerGreen <= 8'hFF;
        else 
				centerGreen <= 8'h00;

        if (switches[2]) 
				centerBlue <= 8'hFF;
        else 
				centerBlue <= 8'h00;

        if (switches[3]) 
				outsideRed <= 8'hFF;
        else 
				outsideRed <= 8'h00;

		  if (switches[4]) 
				outsideGreen <= 8'hFF;
        else 
				outsideGreen <= 8'h00;

        if (switches[5]) 
				outsideBlue <= 8'hFF;
        else 
				outsideBlue <= 8'h00;
		  
		  //change colors to black if not calculated
        if (!(distance_squared <= max_distance_squared)) begin
            VGA_R = 8'h00;
            VGA_G = 8'h00;
            VGA_B = 8'h00;
        end else begin				
            VGA_R <= centerRed + ((outsideRed - centerRed) * distance_squared / max_distance_squared) % 256;
            VGA_G <= centerGreen + ((outsideGreen - centerGreen) * distance_squared / max_distance_squared) % 256;
            VGA_B <= centerBlue + ((outsideBlue - centerBlue) * distance_squared / max_distance_squared) % 256;
        end
    end 

endmodule