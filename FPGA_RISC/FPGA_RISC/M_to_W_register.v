module M_to_W_register(//input 
                        input clk,
                        input reset, 
                        input RegWriteM, 
                        input [1:0] ResultSrcM, 
                        input [31:0]ALU_outM, 
                        input [31:0]ReadDataM, 
                        input [4:0] write_addrM,
                        input [31:0]PC_plus4M,
                        //output
                        output reg [31:0]ALU_outW, 
                        output reg [31:0]ReadDataW, 
                        output reg [4:0] write_addrW,
                        output reg [31:0]PC_plus4W,
                        output reg RegWriteW,   
                        output reg [1:0] ResultSrcW);
                        
    always @(negedge clk or negedge reset)
    begin
    if (~reset)
    begin
        ALU_outW    <=32'd0;
        ReadDataW   <=32'd0;
        write_addrW <=5'd0;
        PC_plus4W   <=32'd0;
        RegWriteW   <=1'd0;
        ResultSrcW  <=2'd0;
    end
    else
    begin
        ALU_outW    <= ALU_outM;
        ReadDataW   <= ReadDataM;
        write_addrW <= write_addrM;
        PC_plus4W   <= PC_plus4M;
        RegWriteW   <= RegWriteM;
        ResultSrcW  <= ResultSrcM;
    end
    end
endmodule