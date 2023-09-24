`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 20:16:52
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(op,memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,aluop);
    input wire[5:0] op;
	output wire memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump;
	output wire[1:0] aluop;
	reg[8:0] controls;
	always @(*) begin
		case (op)
			6'b000000:controls <= 9'b110000010;//R-type
			6'b100011:controls <= 9'b101001000;//lw
			6'b101011:controls <= 9'b001010000;//sw
			6'b000100:controls <= 9'b000100001;//beq
			6'b001000:controls <= 9'b101000000;//addi
			6'b000010:controls <= 9'b000000100;//j
			default:  controls <= 9'b000000000;//error
		endcase
	end
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,aluop} = controls;
	
endmodule