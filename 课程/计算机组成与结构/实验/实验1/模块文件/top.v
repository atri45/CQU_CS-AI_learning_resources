`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 20:14:35
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


module top(num1,op,clk,reset,seg,ans);
input wire[7:0] num1;
input wire[2:0] op;
input wire clk;
input wire reset;
output wire[6:0] seg;
output wire[7:0] ans;
wire[31:0] result;
alu alu1(num1,op,result);
display display1(clk,reset,result,seg,ans);
endmodule
