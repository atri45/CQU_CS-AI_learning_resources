`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 20:18:07
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


module top(
input clk,
input rst,   
output [9:0]led,
output [6:0]seg,
output [7:0]ans
    );
    wire out_clk;
    wire [31:0]inst;
    wire memtoreg, memwrite,alusrc, regdst, regwrite, jump,branch;
    wire[1:0]alucontrol;
    clk_divider clk1(clk,rst,out_clk);
    wire[31:0]pc;
    wire inst_ce;
    PC pc1(out_clk,rst,pc,inst_ce);
    blk_mem_gen_0 blk(.clka(out_clk),.rsta(rst),.addra(pc),.ena(inst_ce),.douta(inst));
    display dis(clk,rst,inst,seg,ans);
    controller crtl(inst[31:26],inst[5:0],memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,alucontrol);
    assign led={alucontrol,branch,jump,regwrite,regdst,alusrc,memwrite,memtoreg};
endmodule
