`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/27 19:33:47
// Design Name: 
// Module Name: sim
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


module sim();
    reg[7:0] num1;
    wire[31:0] num2 = 32'h01;
    reg[2:0] op;
    wire[31:0] result;
    alu test(num1,op,result);
    initial begin
    #10 num1 = 8'h2;
        op = 3'b000;
    #10 op = 3'b001;
    #10 op = 3'b010;
    #10 op = 3'b011;
    #10 op = 3'b100;
    #10 op = 3'b101;
    end
endmodule
