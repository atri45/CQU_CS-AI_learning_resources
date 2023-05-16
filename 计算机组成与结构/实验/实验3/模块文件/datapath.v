`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:51:10
// Design Name: 
// Module Name: datapath
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


module datapath(clk,rst,memtoreg,pcsrc,alusrc,
		regdst,regwrite,jump,alucontrol,zero,pc,instr,aluout,writedata,readdata);
		input clk,rst;
		input memtoreg,pcsrc,alusrc,regdst,regwrite,jump;
		input [2:0]alucontrol;
		output zero;
		output [31:0]pc;
		input [31:0]instr;
		output[31:0] aluout;
		output[31:0] writedata;
		input [31:0]readdata;
		wire[31:0]pc_in;
		pc pc_0(clk,rst,pc_in,pc);
		wire[31:0]pcplus4;
		pc_add pa_0(pc,pcplus4);
		wire[4:0]writereg;
		mux2x5 m25_0(instr[25:16],instr[15:11],regdst,writereg);
		wire[31:0]result;
        mux2x32 m32_0(aluout,readdata,memtoreg,result);	
        wire[31:0]rd1;
		regfile rf(clk,regwrite,instr[25:21],instr[20:16],writereg,result,rd1,writedata);
		wire[31:0]extout;
		wire[31:0]srcB;
		mux2x32 m32_1(writedata,extout,alusrc,srcB);
		alu alu_0(rd1,srcB,alucontrol,aluout,zero);
		signext ext_0(instr[15:0],extout);
		wire[31:0]slout;
		sl2 sl_0(extout,slout);
		wire [31:0]pcbranch;
		adder a0(slout,pcplus4,pcbranch);
		mux2x32 pcmux(pcplus4,pcbranch,pcsrc,pc_in);
endmodule

