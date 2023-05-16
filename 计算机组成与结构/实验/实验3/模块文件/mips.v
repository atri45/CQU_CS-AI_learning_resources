`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 21:08:56
// Design Name: 
// Module Name: mips
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

module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata 
    );
	
	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,overflow;
	wire[2:0] alucontrol;
	controller c(instr[31:26],instr[5:0],zero,memtoreg,memwrite,alusrc,regdst,regwrite,jump,pcsrc,alucontrol);
	datapath dp(clk,rst,memtoreg,pcsrc,alusrc,regdst,regwrite,jump,alucontrol,zero,pc,instr,aluout,writedata,readdata);
	
endmodule

