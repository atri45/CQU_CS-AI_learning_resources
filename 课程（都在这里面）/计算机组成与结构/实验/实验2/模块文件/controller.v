`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 20:17:22
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


module controller(op,funct,memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,alucontrol);
	input wire[5:0] op,funct;
	output wire memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump;
	output wire[2:0] alucontrol;
	wire[1:0] aluop;

	main_decoder x(op,memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,aluop);
	alu_control y(funct,aluop,alucontrol);

endmodule
