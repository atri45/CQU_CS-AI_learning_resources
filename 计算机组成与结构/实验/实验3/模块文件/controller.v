`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:33:22
// Design Name: 
// Module Name: controller
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


module controller(op,funct,zero,memtoreg,memwrite,alusrc,regdst,regwrite,jump,pcsrc,alucontrol);
	input wire[5:0] op,funct;
	input wire zero;
	output wire memtoreg,memwrite,alusrc,regdst,regwrite,jump;
	output pcsrc;
	output wire[2:0] alucontrol;
	wire[1:0] aluop;
	wire branch;
    assign pcsrc = branch & zero;
	main_decoder x(op,memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,aluop);
	alu_control y(funct,aluop,alucontrol);
    
endmodule