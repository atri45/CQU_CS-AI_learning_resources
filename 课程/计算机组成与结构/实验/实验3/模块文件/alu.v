`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 20:43:37
// Design Name: 
// Module Name: alu
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


module alu(SrcA,SrcB,aluControl,aluResult,zero);
input wire [31:0] SrcA, SrcB;
input wire [2:0] aluControl;
output reg [31:0] aluResult;
output  zero;

always @(aluControl) begin
        case(aluControl) 
            3'b000 : aluResult = SrcA & SrcB ;
            3'b001 : aluResult = SrcA | SrcB ;
            3'b010 : aluResult = SrcA + SrcB ;
            3'b110 : aluResult = SrcA - SrcB ;
            3'b111 : aluResult = SrcA < SrcB ? 1:0 ;
            default : aluResult = 32'h00000000 ;
        endcase
    end
assign zero=~|aluResult;
endmodule
