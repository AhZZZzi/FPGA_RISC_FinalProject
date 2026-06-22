module extend5to32(Rs1E,Rs2E,RdE,Rs1Ext,Rs2Ext,RdExt);
	input [4:0] Rs1E,Rs2E,RdE;
	output[31:0] Rs1Ext,Rs2Ext,RdExt;
	
	assign Rs1Ext = {27'b0,Rs1E};
	assign Rs2Ext = {27'b0,Rs2E};
	assign RdExt  = {27'b0,RdE};
endmodule