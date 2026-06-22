module D_to_E_register(//input 
                        input clk,
                        input reset, 
                        input FlushE,
                        input RegWriteD, 
                        input [1:0] ResultSrcD, 
                        input MemWriteD , 
                        input JumpD, 
                        input BranchD ,
                        input JumpR,
                        input UIPC_add,
                        input ALUSrcD, 
                        input [4:0] ALUCtrlD, 
                        input [4:0] Rs1,
                        input [4:0] Rs2,
                        input [31:0]Read_1D, 
                        input [31:0]Read_2D, 
                        input [31:0]PC_nowD, 
                        input [4:0] write_addrD,
                        input [31:0]ImmExtD,
                        input [31:0]PC_plus4D,
                        //output
                        output reg [4:0]Rs1E,
                        output reg [4:0]Rs2E,
                        output reg [31:0]Read_1E, 
                        output reg [31:0]Read_2E, 
                        output reg [31:0]PC_nowE, 
                        output reg [4:0] write_addrE,
                        output reg [31:0]ImmExtE,
                        output reg [31:0]PC_plus4E,
                        output reg RegWriteE, 
                        output reg [1:0] ResultSrcE, 
                        output reg MemWriteE , 
                        output reg JumpE, 
                        output reg BranchE , 
                        output reg ALUSrcE, 
                        output reg [4:0] ALUCtrlE,
                        output reg JumpRE,
                        output reg UIPC_addE);
                        
    always @(negedge clk or negedge reset )
    begin
    if (~reset)
    begin
        Rs1E        <= 5'd0;
        Rs2E        <= 5'd0;
        Read_1E     <= 32'd0;
        Read_2E     <= 32'd0;
        PC_nowE     <=32'd0;
        write_addrE <=5'd0;
        ImmExtE     <=32'd0;
        PC_plus4E   <=32'd0;
        RegWriteE   <=1'd0;
        ResultSrcE  <=2'd0;
        MemWriteE   <=1'd0;
        JumpE       <=1'd0;
        BranchE     <=1'd0;
        ALUSrcE     <=1'd0;
        ALUCtrlE    <=5'd0;
        JumpRE      <=1'b0;
        UIPC_addE   <=1'b0;
    end
	 else if (FlushE)
    begin
        Rs1E        <= 5'd0;
        Rs2E        <= 5'd0;
        Read_1E     <= 32'd0;
        Read_2E     <= 32'd0;
        PC_nowE     <=32'd0;
        write_addrE <=5'd0;
        ImmExtE     <=32'd0;
        PC_plus4E   <=32'd0;
        RegWriteE   <=1'd0;
        ResultSrcE  <=2'd0;
        MemWriteE   <=1'd0;
        JumpE       <=1'd0;
        BranchE     <=1'd0;
        ALUSrcE     <=1'd0;
        ALUCtrlE    <=5'd0;
        JumpRE      <=1'b0;
        UIPC_addE   <=1'b0;
    end
    else
    begin
        Rs1E        <= Rs1;
        Rs2E        <= Rs2;
        Read_1E     <= Read_1D;
        Read_2E     <= Read_2D;
        PC_nowE     <= PC_nowD;
        write_addrE <= write_addrD;
        ImmExtE     <= ImmExtD;
        PC_plus4E   <= PC_plus4D;
        RegWriteE   <= RegWriteD;
        ResultSrcE  <= ResultSrcD;
        MemWriteE   <= MemWriteD;
        JumpE       <= JumpD;
        BranchE     <= BranchD;
        ALUSrcE     <= ALUSrcD;
        ALUCtrlE    <= ALUCtrlD;
        JumpRE      <= JumpR;
        UIPC_addE   <= UIPC_add;
    end
    end
endmodule
