module Program_Counter (clk, reset,StallF ,PC_in, PC_out);
	input clk, reset;
	input StallF;
	input [31:0] PC_in;
	output reg [31:0] PC_out;
	always @ (negedge clk or negedge reset)
	begin
		if(~reset)
			PC_out<=0;
		else if (StallF)
		    PC_out <= PC_out;
		else 
		    PC_out <= PC_in;
	end
endmodule