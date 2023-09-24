`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 19:20:12
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
output reg zero;

always @(aluControl) begin
        case(aluControl) 
            3'b000 : aluResult = SrcA + SrcB ;
            3'b001 : aluResult = SrcA - SrcB ;
            3'b010 : aluResult = SrcA & SrcB ;
            3'b011 : aluResult = SrcA | SrcB ;
            3'b100 : aluResult = ~ SrcA ;
            3'b101 : aluResult = SrcA < SrcB ? 1:0 ;
            default : aluResult = 32'h00000000 ;
        endcase
        if(SrcA == SrcB)
            zero = 1;
        else 
            zero = 0;
    end
endmodule
