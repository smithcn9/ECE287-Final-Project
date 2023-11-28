module radial_image_generator (
    input clk,
    input rst,
    input [10:0] xCoord,
    input [10:0] yCoord,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);

    parameter x_center = 800 / 2;
    parameter y_center = 600 / 2;

    // Define start and end colors (RGB) as parameters
    parameter [7:0] startRed = 8'h00, startGreen = 8'h00, startBlue = 8'hFF; // Example: Blue at center
    parameter [7:0] endRed = 8'hFF, endGreen = 8'h00, endBlue = 8'h00;     // Example: Red at edge

    // Calculation variables
    reg [31:0] distance_squared;
    reg [31:0] max_distance_squared;

    // Initialize max_distance_squared
    initial begin
        max_distance_squared = ((x_center - 0) * (x_center - 0)) + ((y_center - 0) * (y_center - 0));
    end

    always @(posedge clk) begin
        if (rst) begin
            // Reset
            red <= 0;
            green <= 0;
            blue <= 0;
        end else begin
            // Calculate squared distance from the center
            distance_squared = ((xCoord - x_center) * (xCoord - x_center)) + ((yCoord - y_center) * (yCoord - y_center));

            // Interpolate RGB values based on squared distance
            red <= startRed + ((endRed - startRed) * distance_squared / max_distance_squared) % 256;
            green <= startGreen + ((endGreen - startGreen) * distance_squared / max_distance_squared) % 256;
            blue <= startBlue + ((endBlue - startBlue) * distance_squared / max_distance_squared) % 256;
        end
    end
endmodule
