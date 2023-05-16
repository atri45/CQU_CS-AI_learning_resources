`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 21:21:10
// Design Name: 
// Module Name: top2
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


module top2(
input clk,
input rst,
output [9:0]led,
output [31:0]inst
    );
    wire out_clk;
    wire memtoreg, memwrite,alusrc, regdst, regwrite, jump,branch;
    wire[1:0]alucontrol;
    clk_divider clk1(clk,rst,out_clk);
    wire [31:0]pc;
    PC pc1(clk,rst,pc,inst_ce);
    blk_mem_gen_0 blk(clk,rst,inst_ce,pc,inst);
    controller crtl(inst[31:26],inst[5:0],memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,alucontrol);
    assign led={alucontrol,branch,jump,regwrite,regdst,alusrc,memwrite,memtoreg};
endmodule