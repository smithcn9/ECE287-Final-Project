module image_generator(
	input rst, 
	input master_clk, 
	output DAC_clk, 
	output reg [7:0] VGA_R, 
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B, 
	output VGA_hSync, 
	output VGA_vSync, 
	output blank_n,
	input [5:0] switches
);
    
    wire [9:0] pixelColumn;
    wire [9:0] pixelRow;
    wire displayArea;
    wire VGA_clk;
    
    clk_reduce reduce1(master_clk, VGA_clk);
    VGA_gen gen1(VGA_clk, pixelColumn, pixelRow, displayArea, VGA_hSync, VGA_vSync, blank_n);
    assign DAC_clk = VGA_clk;

	 parameter x_center = 640 / 2;
    parameter y_center = 480 / 2;
    
	 reg [7:0] centerRed, centerGreen, centerBlue; //inside
    reg [7:0] outsideRed, outsideGreen, outsideBlue; //outside
	 
	 reg [31:0] distance_squared, max_distance_squared;
	 
    always @(posedge VGA_clk) begin
		  max_distance_squared = ((x_center - 0) * (x_center - 0)) + ((y_center - 0) * (y_center - 0));
		  distance_squared = ((pixelColumn - x_center) * (pixelColumn - x_center)) + ((pixelRow - y_center) * (pixelRow - y_center));
		  
		  centerRed <= switches[0] ? 8'hFF : 8'h00;
		  centerGreen <= switches[1] ? 8'hFF : 8'h00;
		  centerBlue <= switches[2] ? 8'hFF : 8'h00;
		  outsideRed <= switches[3] ? 8'hFF : 8'h00;
        outsideGreen <= switches[4] ? 8'hFF : 8'h00;
        outsideBlue <= switches[5] ? 8'hFF : 8'h00;
		  
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