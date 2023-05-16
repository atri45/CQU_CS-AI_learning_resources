`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 19:23:22
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    output[31:0] pc,
    output reg inst_ce
    );
    reg [31:0] pc_reg; // PC 寄存器
    always @(posedge clk, posedge rst) 
    begin
        if (rst) 
        begin // 复位信号为高电平
          pc_reg <= 32'h0; // 将 PC 寄存器清零
          inst_ce <= 1'b1;
        end 
        else begin // 正常工作状态
          pc_reg <= pc_reg + 4; // PC 寄存器自增 4
          inst_ce <= 1'b1;
        end
    end
    assign pc = pc_reg; // 将 PC 寄存器的值输出到 pc 端口 
endmodule
