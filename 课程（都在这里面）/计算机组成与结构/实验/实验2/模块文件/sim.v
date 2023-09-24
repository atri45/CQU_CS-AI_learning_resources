`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 20:41:21
// Design Name: 
// Module Name: sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim(

    );
	
	reg rst;
	reg clk;
	wire [7:0] ans;
	wire [6:0] seg;
	wire [9:0] led;
	initial
	begin 
		clk = 1'b0;
		rst = 1'b1;
		#10;
		rst = 1'b0;
	end
	always #10 clk = ~clk;
	top top(
		.clk(clk),
		.rst(rst),
		.seg(seg),
	    .ans(ans),
	    .led(led)
		);
endmodule

