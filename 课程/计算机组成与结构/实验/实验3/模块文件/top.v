`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 21:15:17
// Design Name: 
// Module Name: top
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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite
    );
	// wire clk;
	wire[31:0] pc,instr,readdata;

	//   clk_div instance_name(
 //    	// Clock out ports
	//     .clk_out1(hclk),     // output clk_out1
	//    // Clock in ports
	//     .clk_in1(clk)
 //    	); 
   	

	mips mips(clk,rst,pc,instr,memwrite,dataadr,writedata,readdata);
	inst_mem imem(.clka(clk),.addra(pc),.douta(instr));
	data_mem dmem(.clka(clk),.wea(memwrite),.addra(dataadr),.dina(writedata),.douta(readdata));
endmodule