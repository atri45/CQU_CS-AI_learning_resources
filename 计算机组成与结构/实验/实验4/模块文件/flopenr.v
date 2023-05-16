`timescale 1ns / 1ps

module flopenr #(parameter WIDTH = 32)(
                 input clk,rst,en,
                 input [WIDTH-1:0] d,
                 output reg [WIDTH-1:0] q);
    
always @(posedge clk, posedge rst) begin
    if (rst) begin
        q <= 0;
    end else if (en) begin
        q <= d;
    end
end
    
endmodule
    
