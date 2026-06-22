module Decode_stage (//input 
                    input clk,
                    input reset,
                    input RegWriteW,
                    input [4:0]  RdW,
                    input [31:0] result,
                    input [31:0] InstrD,
                    input [31:0] PC_nowD,
                    input [31:0] PC_plus4D,
                    
                    //output
                    output UIPC_add,
                    output JumpR,
                    output jump,
                    output branch,
                    output RegWrite,
                    output MemWrite,
                    output ALUSrc,
                    output [1:0] resultSrc,
                    output [4:0] ALUCtrl,
                    output [31:0]Read_data1,
                    output [31:0]Read_data2,
                    output [31:0]ImmExt);
    wire [2:0] ImmSrc;
    Control_Unit        comp6 (InstrD[6:0],InstrD[14:12],InstrD[31:25],UIPC_add,JumpR,jump,branch,RegWrite,MemWrite,ALUSrc,resultSrc,ALUCtrl,ImmSrc);
    Register_File       comp7 (clk,InstrD[19:15],InstrD[24:20],RdW,Read_data1,Read_data2,result,RegWriteW);
    extend              comp8 (ImmSrc,InstrD[31:7],ImmExt);
endmodule