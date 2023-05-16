`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 22:02:40
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


module testbench();
	reg clk;
	reg rst;

	wire[31:0] writedata,dataadr;
	wire memwrite;

	top dut(clk,rst,writedata,dataadr,memwrite);

	initial begin 
		rst <= 0;
		#200;
		rst <= 1;
	end

	always begin
		clk <= 1;
		#10;
		clk <= 0;
		#10;
	
	end

	always @(negedge clk) begin
		if(memwrite) begin
			/* code */
			if(dataadr === 84 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(dataadr !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
endmodule

