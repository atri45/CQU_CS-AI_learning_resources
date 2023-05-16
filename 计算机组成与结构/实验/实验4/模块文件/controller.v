`timescale 1ns / 1ps

module controller(
        input [5:0] op,funct,
        output regwriteD,memtoregD,memwriteD,branchD,
        output [2:0]alucontrolD,
        output alusrcD,regdstD,jumpD);

wire [1:0]aluop;

main_decoder main_decoder(op,memtoregD,memwriteD,branchD,alusrcD,regdstD,regwriteD,jumpD,aluop);
alu_control alu_control(funct,aluop,alucontrolD);

endmodule
