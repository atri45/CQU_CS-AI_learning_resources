`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 20:32:00
// Design Name: 
// Module Name: mux2x5
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


module mux2x5(A0,A1,S,Y);
input [4:0] A0,A1;
input S;
output reg[4:0] Y;
always@(*)
    begin
    case(S)
        0:Y=A0;
        1:Y=A1;
    endcase
    end
endmodule
