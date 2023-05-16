`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 19:35:50
// Design Name: 
// Module Name: adder
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


module adder(
input inst_ce,
input[31:0] cur_pc,
output[31:0] nxt_pc
    );
    always@(cur_pc)
    begin
        if(inst_ce)
            nxt_pc=cur_pc+4;
    end
endmodule
