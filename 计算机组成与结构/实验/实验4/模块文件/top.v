`timescale 1ns / 1ps


module top(
	input wire clk,rst,
    output wire [31:0] instr, pc, writedata, dataadr,
    output wire memwrite);
    
    wire [31:0] readdata;

    mips mips(clk,rst,instr,readdata,dataadr,memwrite,pc,writedata);
    inst_mem imem(.clka(clk),.rsta(rst),.wea(4'b0000),.addra(pc),.dina(32'b0),.douta(instr));
    data_mem dmem(.clka(clk),.rsta(rst),.wea(memwrite),.addra(dataadr),.dina(writedata),.douta(readdata));

endmodule

