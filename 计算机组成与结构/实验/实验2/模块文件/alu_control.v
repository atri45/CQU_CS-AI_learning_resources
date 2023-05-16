`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 20:15:27
// Design Name: 
// Module Name: alu_control
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


module alu_control(funct,aluop,alucontrol);
    input wire [5:0] funct;
    input wire [1:0] aluop;
    output wire [2:0] alucontrol;
    reg[2:0] result;
    always @(*) begin
		case (aluop)
			2'b00: result = 010;//lw or sw
			2'b01: result = 110;//beq
			2'b10: //R-type
			case (funct)
			6'b100000: result = 010;//add
			6'b100010: result = 110;//subtract
			6'b100100: result = 000;//and
			6'b100101: result = 001;//or
			6'b101010: result = 111;//set-on-less-than
			endcase
		endcase
	end
	
    assign alucontrol = result;
endmodule
