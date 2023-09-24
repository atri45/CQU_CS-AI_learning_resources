`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	input wire[31:0] instr,
	input wire[31:0] readdata,
    output wire[31:0] aluoutM,
	output wire memwriteM,
	output wire[31:0] pc,
	output wire[31:0] writedata);

    wire [31:0] instrD,pc_realnext;
    wire forwardAD, forwardBD,regWriteD, memtoRegD, memWriteD, branchD, aluSrcD, regDstD, jumpD, pcsrcD;
    wire [2:0] aluControlD;
    wire [4:0] rsD,rtD;
    
    wire regWriteE, memtoRegE, memWriteE, aluSrcE, regDstE;
    wire [2:0] aluControlE;
    wire [1:0] forwardAE, forwardBE;
    wire [4:0] rsE, rtE;
    
    wire regWriteM, memtoRegM; 
    wire [4:0] writeRegM;
    
    wire regWriteW, memtoRegW;
    wire[31:0] resultW;
    wire [4:0] writeRegW;
    
    wire stallD, flushE;
    
    // fetch to decode
    flopenrc #(32) FD_instr (clk,rst,~stallD,pcsrcD,instr,instrD);
    
    // decode to execute
    controller c(instrD[31:26],instrD[5:0],regWriteD,memtoRegD,memWriteD,branchD,aluControlD,aluSrcD,regDstD,jumpD);  
    floprc #(8) DE_signals (clk,rst,flushE,
                            {regWriteD, memtoRegD, memWriteD, aluControlD, aluSrcD, regDstD},
                            {regWriteE, memtoRegE, memWriteE, aluControlE, aluSrcE, regDstE});
    
    // execute to memory
    flopenr #(3) EM_signals (clk,rst,1'b1,
                            {regWriteE, memtoRegE, memWriteE},
                            {regWriteM, memtoRegM, memwriteM});
    
    // mem to wb flop for signals
    flopenr #(2) MW_signals (clk,rst,1'b1,
                            {regWriteM, memtoRegM},
                            {regWriteW, memtoRegW});
    
    // datapath
    datapath dp(clk,rst,instrD,readdata,regWriteE,regWriteM,regWriteW,memtoRegE,memtoRegM,memtoRegW,
                aluControlE,aluSrcE,regDstE,jumpD,branchD,pcsrcD,aluoutM,writedata,pc,stallD,flushE);
	
endmodule