module hazard_detect(ForwardAE,ForwardBE,StallD,StallF,FlushD,FlushE,out1,out2,out3);

	input [1:0] ForwardAE,ForwardBE;
	input StallD,StallF,FlushD,FlushE;
	
	output reg out1,out2,out3;
	
	always @(*)
		begin
			if(ForwardAE == 0 | ForwardBE ==0)
				out1 = 0;
			else out1 = 1;
			
			if (StallD == 0 | StallF == 0)
				out2 = 0;
			else out2 = 1;
			
			if (FlushD ==0 | FlushE == 0)
				out3 = 0;
			else out3 = 1;
		end
endmodule

