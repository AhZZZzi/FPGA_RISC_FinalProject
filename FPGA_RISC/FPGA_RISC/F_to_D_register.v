module F_to_D_register(//input
                        input clk,
                        input reset,
                        input FlushD,
                        input StallD,
                        input [31:0]InstrF, 
                        input [31:0] PC_nowF, 
                        input [31:0]PC_plus4F, 
                        //output
                        output reg [31:0]InstrD, 
                        output reg [31:0] PC_nowD, 
                        output reg [31:0]PC_plus4D);
                        
    always @(negedge clk or negedge reset)
    begin   
        if (~reset)
        begin
            InstrD <= 32'd0;
            PC_nowD <= 32'd0;
            PC_plus4D <= 32'd0;
        end
		  else if (FlushD)
        begin
            InstrD <= 32'd0;
            PC_nowD <= 32'd0;
            PC_plus4D <= 32'd0;
        end
        else if(StallD)
        begin   
            InstrD <= InstrD;
            PC_nowD <= PC_nowD;
            PC_plus4D <= PC_plus4D;
        end
        else 
        begin
            InstrD <= InstrF;
            PC_nowD <= PC_nowF;
            PC_plus4D <= PC_plus4F;
        end
    end
endmodule