module choose_output(sel,PC_nowE,RdE,Rs1E,Rs2E,PCTargetE,ReadDataM,WriteDataE,ALU_outE,X);
	input [6:0]sel;
	input [31:0]PC_nowE,RdE,Rs1E,Rs2E,PCTargetE,ReadDataM,WriteDataE,ALU_outE;
	output reg[31:0]X;
	
	always @ (sel)
	begin
		case(sel)
			7'b0000001   : X = PC_nowE;
			7'b0000010   : X = PCTargetE;
			7'b0000100   : X = Rs1E;
			7'b0001000   : X = Rs2E;
			7'b0010000   : X = RdE;
			7'b0100000   : X = ReadDataM;
			7'b1000000   : X = WriteDataE;
			default: X = ALU_outE;
		endcase
	end
endmodule
