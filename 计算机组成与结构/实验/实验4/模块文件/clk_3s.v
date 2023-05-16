`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/08 22:33:47
// Design Name: 
// Module Name: clk_3s
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


module clk_3s(
  input clk,
  output reg clk_3s
);

reg [31:0] count = 0;

always @(posedge clk) begin
  count <= count + 1;
  if (count == 300000000) begin // 100MHz * 3s = 300000000
    count <= 0;
    clk_3s <= ~clk_3s; // 反转3秒时钟信号
  end
end

endmodule
