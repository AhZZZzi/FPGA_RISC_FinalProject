module E_to_M_register(//input 
                        input clk,
                        input reset, 
                        input RegWriteE, 
                        input [1:0] ResultSrcE, 
                        input MemWriteE, 
                        input [31:0]ALU_outE, 
                        input [31:0]WriteDataE, 
                        input [4:0] write_addrE,
                        input [31:0]PC_plus4E,
                        //output
                        output reg [31:0]ALU_outM, 
                        output reg [31:0]WriteDataM, 
                        output reg [4:0] write_addrM,
                        output reg [31:0]PC_plus4M,
                        output reg RegWriteM, 
                        output reg [1:0] ResultSrcM, 
                        output reg MemWriteM);
                        
    always @(negedge clk or negedge reset)
    begin
    if (~reset)
    begin
        ALU_outM    <=32'd0;
        WriteDataM  <=32'd0;
        write_addrM <=5'd0;
        PC_plus4M   <=32'd0;
        RegWriteM   <=1'd0;
        ResultSrcM  <=2'd0;
        MemWriteM   <=1'd0;
    end
    else
    begin
        ALU_outM    <= ALU_outE;
        WriteDataM  <= WriteDataE;
        write_addrM <= write_addrE;
        PC_plus4M   <= PC_plus4E;
        RegWriteM   <= RegWriteE;
        ResultSrcM  <= ResultSrcE;
        MemWriteM   <= MemWriteE;
       
    end
    end
endmodule