// Module for generating an image based on input switches and VGA signal generation
module image_generator(
	input rst, 
	input clk, 
	output reg VGA_clk, 
	output reg [7:0] VGA_R, 
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B, 
	output hsync, 
	output vsync, 
	output VGA_BLANK_N,
	input [3:0] switches
);
    
	 // Pixel coordinates and display area signal
    wire [9:0] yPixel;
    wire [9:0] xPixel;
    wire displayArea;
    
	 //clock divider
    always@(posedge clk) begin
		VGA_clk <= ~VGA_clk;
	 end
	 
    VGA_gen gen1(VGA_clk, yPixel, xPixel, displayArea, hsync, vsync, VGA_BLANK_N);

	 parameter x_center = 640 / 2;
    parameter y_center = 480 / 2;
    
	 reg [7:0] centerRed, centerGreen, centerBlue; //center color
    reg [7:0] outsideRed, outsideGreen, outsideBlue; //outside color
	 
	 reg [31:0] distance_squared, max_distance_squared;
	 
	 
	 // State definitions for switch cases
	 parameter BLACK = 3'b000;
	 parameter RED = 3'b001;
	 parameter GREEN = 3'b010;
	 parameter YELLOW = 3'b011;
	 parameter BLUE = 3'b100;
	 parameter MAGENTA = 3'b101;
	 parameter CYAN = 3'b110;
	 parameter WHITE = 3'b111;
	 
	 // Main logic block for image generation
    always @(posedge VGA_clk) begin
		  max_distance_squared = ((x_center - 0) * (x_center - 0)) + ((y_center - 0) * (y_center - 0));
		  distance_squared = ((yPixel - x_center) * (yPixel - x_center)) + ((xPixel - y_center) * (xPixel - y_center));
		  
		  outsideRed <= 8'hFF;
 
		  outsideGreen <= 8'hFF;
 
		  outsideBlue <= 8'hFF;
		  
		case(switches)
			BLACK: begin
				centerRed <= 8'h00;
				centerGreen <= 8'h00;
				centerBlue <= 8'h00;
			end
			RED: begin
				centerRed <= 8'hFF;
				centerGreen <= 8'h00;
				centerBlue <= 8'h00;
			end
			GREEN: begin
				centerRed <= 8'h00;
				centerGreen <= 8'hFF;
				centerBlue <= 8'h00;
			end
			BLUE: begin
				centerRed <= 8'h00;
				centerGreen <= 8'h00;
				centerBlue <= 8'hFF;
			end
			YELLOW: begin
				centerRed <= 8'hFF;
				centerGreen <= 8'hFF;
				centerBlue <= 8'h00;
			end
			MAGENTA: begin
				centerRed <= 8'hFF;
				centerGreen <= 8'h00;
				centerBlue <= 8'hFF;
			end
			CYAN: begin
				centerRed <= 8'h00;
				centerGreen <= 8'hFF;
				centerBlue <= 8'hFF;
			end
			WHITE: begin
				centerRed <= 8'hFF;
				centerGreen <= 8'hFF;
				centerBlue <= 8'hFF;
			end
		endcase

 
		  
		  //change colors to black if not calculated
        if (!(distance_squared <= max_distance_squared)) begin
            VGA_R = 8'h00;
            VGA_G = 8'h00;
            VGA_B = 8'h00;
        end else begin				
            VGA_R <= centerRed + ((outsideRed - centerRed) * distance_squared / max_distance_squared);
            VGA_G <= centerGreen + ((outsideGreen - centerGreen) * distance_squared / max_distance_squared);
            VGA_B <= centerBlue + ((outsideBlue - centerBlue) * distance_squared / max_distance_squared);
        end
    end 

endmodule