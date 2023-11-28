module vga_driver(
    input clk,
    input rst,
	 //inputs passed from coordinate system
	 input [10:0] xCoord,
    input [10:0] yCoord,
    // RGB inputs from the image generation module
    input [7:0] red,
    input [7:0] green,
    input [7:0] blue,
    // VGA output signals
    output reg vga_h_sync,
    output reg vga_v_sync,
    output reg [7:0] vga_red,
    output reg [7:0] vga_green,
    output reg [7:0] vga_blue
);


	// horizontal timings, adjusted for 800x600 @ 60Hz
	
	parameter HA_END = 10'd799;           // end of active pixels
	parameter HS_STA = HA_END + 40;       // sync starts after front porch
	parameter HS_END = HS_STA + 128;      // sync ends
	parameter WIDTH  = 10'd1055;          // last pixel on line (after back porch)

	// vertical timings for 800x600
	parameter VA_END = 10'd599;           // end of active pixels
	parameter VS_STA = VA_END + 1;        // sync starts after front porch
	parameter VS_END = VS_STA + 4;        // sync ends
	parameter HEIGHT = 10'd627;           // last line on screen (after back porch)

	reg active_pixels;
	

    always @(posedge clk) begin
        if (rst) begin
            // Reset sync signals and RGB outputs
            vga_h_sync <= 1'b1;
            vga_v_sync <= 1'b1;
            vga_red <= 8'b0;
            vga_green <= 8'b0;
            vga_blue <= 8'b0;
        end else begin
            // Sync signal generation
            vga_h_sync <= ~((xCoord >= HS_STA) && (xCoord < HS_END));
            vga_v_sync <= ~((yCoord >= VS_STA) && (yCoord < VS_END));
            active_pixels = (xCoord < HA_END) && (yCoord < VA_END);

            // Assign RGB values
            if (active_pixels) begin
                vga_red <= red;
                vga_green <= green;
                vga_blue <= blue;
            end else begin
                vga_red <= 8'b0;
                vga_green <= 8'b0;
                vga_blue <= 8'b0;
            end
        end
    end
endmodule
