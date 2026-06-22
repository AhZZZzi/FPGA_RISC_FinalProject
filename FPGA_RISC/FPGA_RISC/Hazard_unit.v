module Hazard_unit (//input 
                    //Foward input
                    input [4:0]Rs1E,
                    input [4:0]Rs2E,
                    input [4:0] RdM,
                    input [4:0] RdW,
                    input RegWriteM,
                    input RegWriteW,
                    //Stall input
                    input [4:0]Rs1D,
                    input [4:0]Rs2D,
                    input [4:0] RdE,
                    input ResultSrcE0,
                    //Control hazard stall input
                    input PCSrcE,
                    // output 
                    // Forward output
                    output reg [1:0] ForwardAE,
                    output reg [1:0] ForwardBE,
                    //Stall output
                    output reg StallF,
                    output reg StallD,
                    output reg FlushE,
                    //Control hazard stall output
                    output reg FlushD,
                    output reg lwStall
                    );
    // Forward method
    always @( Rs1E or Rs2E or RdM or RdW or RegWriteM or RegWriteW)
    begin   
    
        // ForwardA
        if(((Rs1E == RdM) & RegWriteM) & (Rs1E != 0))
            ForwardAE = 2'b10;
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 0))
            ForwardAE = 2'b01;
        else ForwardAE = 2'b00;
        //ForwardB 
        if(((Rs2E == RdM) & RegWriteM) & (Rs2E != 0))
            ForwardBE = 2'b10;
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 0))
            ForwardBE = 2'b01;
        else ForwardBE = 2'b00;
    end
    // Stall Method
    always @(*)
    begin
        lwStall = ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));
    end
    
    always @(*)
    begin
        StallD = lwStall;
        StallF = lwStall;
        FlushD = PCSrcE;
        FlushE = lwStall | PCSrcE; 
    end    
endmodule