`timescale 1ns / 1ps

module hazard(input [4:0] rsD,
              input [4:0] rtD,
              input [4:0] rsE,
              input [4:0] rtE,
              input [4:0] writeregE,
              input [4:0] writeregM,
              input [4:0] writeregW,
              input regwriteE,
              input regwriteM,
              input regwriteW,
              input memtoregE,
              input memtoregM,
              input branchD,            
              output reg[1:0] forwardAE,
              output reg[1:0] forwardBE,
              output reg forwardAD,
              output reg forwardBD,
              output wire stallF, stallD, flushE);

    // --data hazard--
    always @(*) begin
        if ((rsE != 0) && (rsE == writeregM) && regwriteM) begin
            forwardAE = 2'b10;
        end else if ((rsE != 0) && (rsE == writeregW) && regwriteW) begin
            forwardAE = 2'b01;
        end else begin
            forwardAE = 2'b00;
        end
    end
    
    always @(*) begin
        if ((rtE != 0) && (rtE == writeregM) && regwriteM) begin
            forwardBE = 2'b10;
        end else if ((rtE != 0) && (rtE == writeregW) && regwriteW) begin
            forwardBE = 2'b01;
        end else begin
            forwardBE = 2'b00;
        end
    end

    
    // --pipeline stall--
    wire lwstall, branchstall;
    // 判断 decode 阶段 rs 或 rt 的地址是否是 lw 指令要写入的地址；
    assign lwstall = ((rsD == rtE) || (rtD == rtE)) && memtoregE; 
    
    
    // --control hazard--
    always @(*) begin
        if ((rsD != 0) && (rsD == writeregM) && regwriteM) begin
            forwardAD = 1'b1;
        end else begin
            forwardAD = 1'b0;
        end
    end
    
    always @(*) begin
        if ((rtD != 0) && (rtD == writeregM) && regwriteM) begin
            forwardBD = 1'b1;
        end else begin
            forwardBD = 1'b0;
        end
    end
    
    assign branchstall = branchD && regwriteE && 
                           (writeregE == rsD || writeregE == rtD) 
                           || branchD && memtoregM &&
                           (writeregM == rsD || writeregM == rtD);  
    assign stallF = lwstall || branchstall;
    assign stallD = lwstall || branchstall;
    assign flushE = lwstall || branchstall;

endmodule
