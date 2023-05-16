module datapath(
		input clk,rst,
		input [31:0]instrD,
		input [31:0]readdata,
        input regwriteE,
        input regwriteM,
        input regwriteW,
        input memtoregE,
        input memtoregM,
        input memtoregW,
		input [2:0]alucontrolE,
		input alusrcE,
		input regdstE,
		input jumpD,
		input branchD,
		output pcsrcD,
		output[31:0] aluoutM,
		output[31:0] writedataM,
        output [31:0]pc,
        output stallD, flushE,
        input [4:0] SW,
        output wire[31:0]rfsw
        );
			
        
		// --fetch--
		// pc: in
		wire[31:0]pc_in, pcplus4F, pcbranchM;	
		wire stallF;
		mux2x32 pcmux(pcplus4F,pcbranchM,pcsrcD,pc_in);
		flopenr #(32) getpc(clk,rst,~stallF,pc_in,pc);
		
		// pc + 4
		adder pa_0(pc,4,pcplus4F);
		
		
		// --decode--
		// pc: fetch to decode
		wire[31:0]pcplus4D;
		flopenrc #(32) FD_pcplus4(clk,rst,~stallD,pcsrcD,pcplus4F,pcplus4D);
		
		// wirte data to reg
		wire [4:0] writeregW;
		wire[31:0]resultW;
        wire[31:0]rd1D,rd2D;
		regfile rf(clk,rst,regwriteW,instrD[25:21],instrD[20:16],writeregW,resultW, rd1D,rd2D,SW,rfsw);
		
		// determine pcsrcD
		wire [31:0] equalsrc1, equalsrc2;
		wire equalD, forwardAD, forwardBD;
		mux2x32 m32_equal1(rd1D,aluoutM,forwardAD,equalsrc1);
		mux2x32 m32_equal2(rd2D,aluoutM,forwardBD,equalsrc2);
		assign equalD = (equalsrc1==equalsrc2);
		assign pcsrcD = branchD & equalD;
		
		// instrD[15:0] sign-extended
		wire[31:0]signlmmD;
		signext ext_0(instrD[15:0],signlmmD);
		
		wire[31:0]signlmmE, pcplus4E;
        floprc#(64) DE_signlmm(clk,rst,flushE,signlmmD, signlmmE);
        floprc#(64) DE_pcplus4(clk,rst,flushE,pcplus4D, pcplus4E);
		
		
		// --execute--
		// instrD[15:0] << 2
		wire[31:0]instr_sl2;
		sl2 sl_0(signlmmE,instr_sl2);
		
		// add pc get pcbranch
		wire [31:0]pcbranchE;
        adder pcbrachadder(instr_sl2,pcplus4E,pcbranchE);
		
		// rs, rt, rd: decode to execute
		wire [4:0]  rsD,rtD,rdD,rdE,rsE,rtE;
        assign rsD = instrD[25:21];
        assign rtD = instrD[20:16];
        assign rdD = instrD[15:11];
        floprc#(15) DE_rstd(clk,rst,flushE,{rsD,rtD,rdD},{rsE,rtE,rdE});
		
		// rd1, rd2: decode to execute
        wire[31:0]rd1E,rd2E;
		floprc#(32) DE_rd1(clk,rst,flushE,rd1D,rd1E);
		floprc#(32) DE_rd2(clk,rst,flushE,rd2D,rd2E);
		
		// determine srcAE and srcBE(include hazard)
		wire[31:0]srcAE,srcBE;
        wire[31:0]srcB0;
        wire [1:0] forwardAE, forwardBE;
        mux3 #(32) mux_ALUsrcA(rd1E,resultW,aluoutM,forwardAE,srcAE);
        mux3 #(32) mux_ALUsrcB0(rd2E,resultW,aluoutM,forwardBE,srcB0);
        mux2x32 mux_ALUsrcB1(srcB0,signlmmE,alusrcE,srcBE);
        
        // alu calculate
        wire[31:0] aluoutE;
		alu alu_0(srcAE,srcBE,alucontrolE,aluoutE);
		
		// writedaraE
		wire[31:0] writedataE;
		assign writedataE = srcB0;
		
		// writeregE
		wire [4:0]writeregE;
		mux2x5 m25_0(rtE,rdE,regdstE,writeregE);
		
		
		// --memory--
		// aluout, writedata, writereg: execute to memory
		wire [4:0] writeregM;
		flopenr #(32) EM_aluout(clk,rst,1,aluoutE,aluoutM);		
		flopenr #(32) EM_writedata(clk,rst,1,writedataE,writedataM);
		flopenr #(32) EM_writereg(clk,rst,1,writeregE,writeregM);
		flopenr #(32) EM_pcbranch(clk,rst,1,pcbranchE,pcbranchM);
		
		
		// --writeback--
		// aluout, writedata, writereg: execute to memory
		wire[31:0]aluoutW,readdataW;
		flopenr #(32) MF_aluout(clk,rst,1,aluoutM,aluoutW);
		flopenr #(32) MF_readdata(clk,rst,1,readdata,readdataW);		
		flopenr #(5) MW_writereg(clk,rst,1,writeregM,writeregW);	
		
		// determine resultW	
		mux2x32 m32_0(aluoutW,readdataW,memtoregW,resultW);	

        // hazard module
        hazard hazard(rsD,rtD,rsE,rtE,writeregE,writeregM,writeregW,regwriteE,regwriteM,regwriteW,memtoregE,memtoregM,
                      branchD,forwardAE,forwardBE,forwardAD,forwardBD,stallF,stallD,flushE);
        
endmodule