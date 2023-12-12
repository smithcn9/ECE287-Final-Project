module VGA_gen(VGA_clk, xPixel, yPixel, displayArea, VGA_hSync, VGA_vSync, VGA_BLANK_N);

    input VGA_clk;
    output reg [9:0] xPixel, yPixel; 
    output reg displayArea;  
    output VGA_hSync, VGA_vSync, VGA_BLANK_N;

    reg p_hSync, p_vSync; 
    
    // Horizontal timings
    parameter HA_END = 10'd639; // end of active pixels
    parameter HS_STA = 10'd655; // sync starts after front porch
    parameter HS_END = 10'd747; // sync ends
    parameter WIDTH  = 10'd793; // last pixel on line (after back porch)

    // Vertical timings
    parameter VA_END = 10'd479; // end of active pixels
    parameter VS_STA = 10'd490; // sync starts after front porch
    parameter VS_END = 10'd492; // sync ends
    parameter HEIGHT = 10'd525; // last line on screen (after back porch)

    always@(posedge VGA_clk)
    begin
        if (xPixel == WIDTH)
            xPixel <= 0;
        else
            xPixel <= xPixel + 1;
    end

    always@(posedge VGA_clk)
    begin
        if (xPixel == WIDTH)
        begin
            if (yPixel == HEIGHT)
                yPixel <= 0;
            else
                yPixel <= yPixel + 1;
        end
    end
    
    always@(posedge VGA_clk)
    begin
        displayArea <= ((xPixel < HA_END) && (yPixel < VA_END)); 
    end

    always@(posedge VGA_clk)
    begin
        p_hSync <= ((xPixel >= HS_STA) && (xPixel < HS_END)); 
        p_vSync <= ((yPixel >= VS_STA) && (yPixel < VS_END)); 
    end
 
    assign VGA_vSync = ~p_vSync; 
    assign VGA_hSync = ~p_hSync;
    assign VGA_BLANK_N = displayArea;
endmodule
