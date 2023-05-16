`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/03 19:29:54
// Design Name: 
// Module Name: clk_divider
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


module clk_divider (
  input clk,      // 输入时钟信号
  input rst,    // 外部重置信号
  output reg out  // 输出时钟脉冲信号
);

parameter DIVIDER_THRESHOLD = 50000000;  // 阈值为 100Mhz / 2 = 50,000,000

reg [31:0] counter;  // 计数器
reg flag = 1'b0;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    counter <= 0;
    out <= 0;
  end 
  else 
  begin
    if (counter < 35 && flag == 0)
    begin
        out <= ~out;
        counter <= counter + 1; 
    end
    else if (counter >= DIVIDER_THRESHOLD) 
    begin
      out <= ~out;  // 输出时钟脉冲信号
      counter <= 0; // 重置计数器
    end 
    else 
    begin
      flag = 1;
      counter <= counter + 1; // 增加计数器的值
    end
  end
end

endmodule