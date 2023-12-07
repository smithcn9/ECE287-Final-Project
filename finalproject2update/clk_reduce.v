module clk_reduce(master_clk, VGA_clk);

	input master_clk; //50MHz clock
	output reg VGA_clk; //25MHz clock

	always@(posedge master_clk)
	begin
		VGA_clk <= ~VGA_clk;
	end
endmodule