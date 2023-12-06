//Steven Ventura aka Gangsthurh
//made this program on 4/3/2017
//bounces a ball up and down and left and right

module BallBounceVGA(start, master_clk, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n);
	
	input master_clk;
	output reg [7:0]VGA_R, VGA_G, VGA_B;  //Red, Green, Blue VGA signals
	output VGA_hSync, VGA_vSync, DAC_clk, blank_n; //Horizontal and Vertical sync signals
	wire [9:0] pixelColumn; //current x pixel coordinate
	wire [9:0] pixelRow; //current y pixel coordinate
	wire displayArea; //boolean: current x and y pixel are within the screen bounds
	wire VGA_clk; //25 MHz
	wire BALL_clk; //28 frames per second on 60MHz
	wire [9:0] ballX, ballY;
	wire R;
	wire G;
	wire B;
	input start;
	

	clk_reduce reduce1(master_clk, VGA_clk); //Reduces 50MHz clock to 25MHz
	game_fps gfps1(master_clk,BALL_CLK);
	//tells us which row and column we are on. also generates the hsync,vsync, and blank_n output signals.
	VGA_gen gen1(VGA_clk, pixelColumn, pixelRow, displayArea, VGA_hSync, VGA_vSync, blank_n);
	assign DAC_clk = VGA_clk;
	
	
	
	///////////////////INSTRUCTIONS FOR DRAWING TO THE SCREEN
	//move the ball
	ball_move bm1(BALL_CLK,ballX,ballY);
	
	parameter CEILING = 300,
			  FLOOR   = 180,
			  LEFTWALL = 15,
			  RIGHTWALL = 625,
			  MIDDLEY  = 240,
			  BALLSIZE = 15,
			  UP = 1,//"up" is actually down on the monitor because 0,0 is on the topleft
			  DOWN = 0,
			  LEFT = 0,
			  RIGHT = 1;

	
	//drawing
	reg middleSection=0, boundaries=0, ballArea = 0;
	
	always @(posedge VGA_clk) begin
	
	//now drawing instructions
	boundaries <= ~(pixelRow >= FLOOR && pixelRow <= CEILING && pixelColumn <= RIGHTWALL && pixelColumn >= LEFTWALL);
	ballArea <= pixelRow <= ballY+BALLSIZE && pixelRow >= ballY && pixelColumn <= ballX+BALLSIZE && pixelColumn >= ballX; 
	middleSection <= ~boundaries && ~ballArea;
	
	end
	
	///////////////////END OF INSTRUCTIONS FOR DRAWING TO THE SCREEN
	//draw to the screen
	assign R = displayArea && ballArea;
	assign G = displayArea && boundaries;
	assign B = displayArea && middleSection;
	always@(posedge VGA_clk)
	begin
		VGA_R = {8{R}};
		VGA_G = {8{G}};
		VGA_B = {8{B}};
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


//////////////////////////////////////////////////////////////////////////////////////////////////////
/*
VGA_gen documentation:
here's how it scans through the screen:
int r, c;
boolean displayArea, VGA_vSync, VGA_hSync, blank_n;

for (r = 0; r < maxV; r++)//yCount
{
for (c = 0; c < maxH; c++)//xCount
{
displayArea = (r <= maxV && c <= maxH);
VGA_vSync = ~(r >= syncV && r < porchVB);
VGA_hSync = ~(c >= syncH && c < porchHB);
blank_n = displayArea;
}
}

*/
module VGA_gen(VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n);

	input VGA_clk;
	output reg [9:0]xCount, yCount; 
	output reg displayArea;  
	output VGA_hSync, VGA_vSync, blank_n;

	reg p_hSync, p_vSync; 
	
	integer porchHF = 640; //start of horizntal front porch
	integer syncH = 655;//start of horizontal sync
	integer porchHB = 747; //start of horizontal back porch
	integer maxH = 793; //total length of line.

	integer porchVF = 480; //start of vertical front porch 
	integer syncV = 490; //start of vertical sync
	integer porchVB = 492; //start of vertical back porch
	integer maxV = 525; //total rows. 

	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)
			xCount <= 0;
		else
			xCount <= xCount + 1;
	end
	// 93sync, 46 bp, 640 display, 15 fp
	// 2 sync, 33 bp, 480 display, 10 fp
	always@(posedge VGA_clk)
	begin
		if(xCount === maxH)//at the end of each row (last column)
		begin
			if(yCount === maxV)//if we are at the last row
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

module game_fps(master_clk,gameRefresh);
input master_clk;
output reg gameRefresh = 0;

	reg [21:0]count = 0;	
	
	always@(posedge master_clk)
	begin
		if(count < 1777777)
		begin
		count <= count + 1;
		end	
		else begin
		gameRefresh <= ~gameRefresh;
		count <= 0;
		end
	end
endmodule


module ball_move(BALL_clk, ballX, ballY);

parameter CEILING = 300,
			  FLOOR   = 180,
			  LEFTWALL = 15,
			  RIGHTWALL = 625,
			  MIDDLEY  = 240,
			  BALLSIZE = 15,
			  UP = 1,//"up" is actually down on the monitor because 0,0 is on the topleft
			  DOWN = 0,
			  LEFT = 0,
			  RIGHT = 1,
			  BALLSPEEDX = 2,
			  BALLSPEEDY = 3;
input BALL_clk;
reg vDirection = 1;
reg hDirection = 1;
output reg [9:0] ballX = 240, ballY = MIDDLEY;
	
	always @(posedge BALL_clk) begin
	
	if (ballY+BALLSIZE > CEILING) begin
	ballY <= CEILING - BALLSIZE - 1;
	vDirection <= DOWN;
	end//end hit the ceiling
	if (ballY < FLOOR) begin
	ballY <= FLOOR + 1;
	vDirection <= UP;
	end
	
	if (ballX+BALLSIZE > RIGHTWALL) begin
	ballX <= RIGHTWALL-BALLSIZE-1;
	hDirection <= LEFT;
	end
	
	if (ballX < LEFTWALL) begin
	ballX <= LEFTWALL+1;
	hDirection <= RIGHT;
	end
	
	//move the ball
	if (hDirection == RIGHT)
		ballX <= ballX + BALLSPEEDX;
	else
		ballX <= ballX - BALLSPEEDX;

	if (vDirection == UP)
		ballY <= ballY + BALLSPEEDY;
	else
		ballY <= ballY - BALLSPEEDY;
		
	end//end always


endmodule