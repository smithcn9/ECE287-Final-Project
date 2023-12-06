module MAIN(start, master_clk, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n);
    
    input master_clk, start;
    output reg [7:0] VGA_R, VGA_G, VGA_B; // Red, Green, Blue VGA signals
    output VGA_hSync, VGA_vSync, DAC_clk, blank_n; // Horizontal and Vertical sync signals
    wire [9:0] pixelColumn, pixelRow; // Current x and y pixel coordinates
    wire displayArea, VGA_clk; // Display area and 25 MHz clock

    // Instantiate clk_reduce and VGA_gen modules
    clk_reduce reduce1(master_clk, VGA_clk);
    VGA_gen gen1(VGA_clk, pixelColumn, pixelRow, displayArea, VGA_hSync, VGA_vSync, blank_n);
    assign DAC_clk = VGA_clk;

    // Radial gradient parameters and variables
    parameter x_center = 640 / 2;
    parameter y_center = 480 / 2;
    parameter [7:0] startRed = 8'h00, startGreen = 8'h00, startBlue = 8'hFF; // Blue at center
    parameter [7:0] endRed = 8'hFF, endGreen = 8'h00, endBlue = 8'h00; // Red at edge
    reg [31:0] distance_squared, max_distance_squared;

    // Initialize max_distance_squared
    initial begin
        max_distance_squared = ((x_center - 0) * (x_center - 0)) + ((y_center - 0) * (y_center - 0));
    end

    always @(posedge VGA_clk) begin
        if (start) begin // Assuming 'start' is used as a reset signal
            VGA_R <= 0;
            VGA_G <= 0;
            VGA_B <= 0;
        end else begin
            // Calculate squared distance from the center
            distance_squared = ((pixelColumn - x_center) * (pixelColumn - x_center)) + 
                               ((pixelRow - y_center) * (pixelRow - y_center));

            // Interpolate RGB values based on squared distance
            VGA_R <= startRed + ((endRed - startRed) * distance_squared / max_distance_squared) % 256;
            VGA_G <= startGreen + ((endGreen - startGreen) * distance_squared / max_distance_squared) % 256;
            VGA_B <= startBlue + ((endBlue - startBlue) * distance_squared / max_distance_squared) % 256;
        end
    end

endmodule


/////////////////////////////////////////////////////////////////////////////////////////////////

//clock q is half the frequency of p
module clk_reduce(master_clk, VGA_clk);

	input master_clk; //50MHz clock
	output reg VGA_clk; //25MHz clock

	always@(posedge master_clk)
	begin
		VGA_clk <= ~VGA_clk;
	end
endmodule

 
module VGA_gen(VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n);

	input VGA_clk;
	output reg [9:0]xCount, yCount; 
	output reg displayArea;  
	output VGA_hSync, VGA_vSync, blank_n;

	reg p_hSync, p_vSync; 
	
	parameter porchHF = 640; //start of horizntal front porch
	parameter syncH = 655;//start of horizontal sync
	parameter porchHB = 747; //start of horizontal back porch
	parameter maxH = 793; //total length of line.

	parameter porchVF = 480; //start of vertical front porch 
	parameter syncV = 490; //start of vertical sync
	parameter porchVB = 492; //start of vertical back porch
	parameter maxV = 525; //total rows. 

	always@(posedge VGA_clk)
	begin
		if(xCount == maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1;
	end
	// 93sync, 46 bp, 640 display, 15 fp
	// 2 sync, 33 bp, 480 display, 10 fp
	always@(posedge VGA_clk)
	begin
		if(xCount == maxH)//at the end of each row (last column)
		begin
			if(yCount == maxV)//if we are at the last row
				yCount <= 0;
			else
			yCount <= yCount + 1;
		end
	end
	
	always@(posedge VGA_clk)
	begin
		displayArea <= ((xCount < porchHF) && (yCount < porchVF)); 
	end

	always@(posedge VGA_clk)
	begin
		p_hSync <= ((xCount >= syncH) && (xCount < porchHB)); 
		p_vSync <= ((yCount >= syncV) && (yCount < porchVB)); 
	end
 
	assign VGA_vSync = ~p_vSync; 
	assign VGA_hSync = ~p_hSync;
	assign blank_n = displayArea;
endmodule		
