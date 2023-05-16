`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 19:46:21
// Design Name: 
// Module Name: pc
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


module pc (input clk, input rst, input [31:0] pc_in, output reg [31:0] pc_out);

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            pc_out <= 32'h0; // 将 pc_out 初始化为 0
        end else begin
            pc_out <= pc_in; // 将 pc_in 的值赋给 pc_out
        end
    end

endmodule

