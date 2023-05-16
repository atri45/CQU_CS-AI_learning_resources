module mux3 #(parameter WIDTH = 32)
             (input [WIDTH-1:0] a, b, c,
              input [1:0] s,
              output [WIDTH-1:0] y);
    
    assign y = (s == 2'b00) ? a : 
               (s == 2'b01) ? b :
               (s == 2'b10) ? c :
               {WIDTH{1'bx}};
endmodule
