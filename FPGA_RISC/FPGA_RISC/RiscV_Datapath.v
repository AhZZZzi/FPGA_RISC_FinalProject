module RiscV_Datapath (// input
                        input clk,
                        input reset,
                        
                        //output
                        output [1:0]ForwardAE,
                        output [1:0]ForwardBE,
                        output StallF,
                        output StallD,
                        output FlushE,
                        output FlushD,
                        
                        // output [31:0]WriteData,
                        // output [31:0]Read_data1,
                        // output [31:0] PC_jump,
                        //fetch
                        
                        //decode
                        
                        output BranchE,
                        output JumpE,
                        output JumpRE,
                        
                       
                        output PCSrcE,
                        output [31:0]PC_nowE,
                        
                        output [4:0] Rs1E,
                        output [4:0] Rs2E,
                        output [4:0] RdE,
                        output [31:0]PCTargetE,
                        output [31:0]ReadDataM,
                        output [31:0]WriteDataE,
                        output [31:0]ALU_outE
                        );
    
    
                 
    wire branch_valid;
   
    wire [31:0]PC_now;
    
    wire [31:0]result;
    
    wire [4:0] ALUCtrlE;
    wire [1:0] resultSrcE;
    wire [31:0]ImmExt;
    
    wire [31:0]ALU_outM;
    wire [31:0]WriteDataM;
    wire [31:0]PC_plus4M;
    wire [31:0]NonUSrc;
    wire [4:0] RdM;
    wire [4:0] RdW;
    wire RegWriteM;
    wire RegWriteW;
    wire [31:0]PC_next;
    wire [31:0] PC_jump;
    
    wire UIPC_addE;
    wire [31:0]Read_data1E;
    wire [31:0]Read_data2E;
    wire [31:0]ImmExtE;
    wire [31:0]PC_plus4E;
    wire JumpR;
    wire jump;
    wire branch;
    wire RegWrite;
    wire MemWrite;
    wire ALUSrc;
    wire [1:0]resultSrc;
    wire [4:0]ALUCtrl;
    wire [31:0] Read_data2;
    wire UIPC_add;
    wire [31:0]Read_data1;
    wire RegWriteE;
    wire MemWriteE;
    wire ALUSrcE;
    wire [2:0]ImmSrc;
    wire [31:0]SrcBE;
    wire [31:0]SrcAE;
    wire [31:0]Instr;
    wire [31:0]InstrD;
    wire [31:0]PC_nowD;
    wire [31:0]PC_plus4D;
    wire [31:0]PC_plus4;
    // wire [31:0]InstrD;
    // wire [31:0]PC_nowD;
    // wire [31:0]PC_plus4D;
    
    Fetch_stage         comp1 (clk,reset,StallF,PCTargetE,PCSrcE,PC_next,Instr,PC_now,PC_plus4);
    F_to_D_register     comp2 (clk,reset,FlushD,StallD,Instr,PC_now,PC_plus4,InstrD,PC_nowD,PC_plus4D);
    
    //decode
    // wire [31:0] Read_data2;
    // wire RegWriteE;
    // wire MemWriteE;
    // wire ALUSrcE;
    // wire BranchE;
    // wire JumpE;
    // wire JumpRE;
    // wire UIPC_addE;
    // wire [31:0]Read_data1E;
    // wire [31:0]Read_data2E;
    // wire [31:0]WriteDataE;
    // wire [31:0]ImmExtE;
    // wire [31:0]PC_plus4E;
    // wire [31:0]PC_nowE;
    // wire [4:0] RdE;
    // wire [4:0] Rs1E;
    // wire [4:0] Rs2E;
    // wire [4:0] ALUCtrlE;
    // wire [1:0] resultSrcE;
    
    
    Decode_stage        comp3(clk,reset,RegWriteW,RdW,result,InstrD,PC_nowD,PC_plus4D,UIPC_add,JumpR,jump,branch,RegWrite,MemWrite,ALUSrc,resultSrc,ALUCtrl,Read_data1,Read_data2,ImmExt);
    D_to_E_register     comp9(clk,reset,FlushE,RegWrite,resultSrc,MemWrite,jump,branch,JumpR,UIPC_add,ALUSrc,ALUCtrl,
                                InstrD[19:15],InstrD[24:20],Read_data1,Read_data2,PC_nowD,InstrD[11:7],ImmExt,PC_plus4D,Rs1E,Rs2E,Read_data1E,
                                Read_data2E,PC_nowE,RdE,ImmExtE,PC_plus4E,RegWriteE,resultSrcE,MemWriteE,JumpE,BranchE,ALUSrcE,ALUCtrlE,JumpRE,UIPC_addE);
    
    //execute 
    // wire [31:0]ALU_outM;
    // wire [31:0]WriteDataM;
    // wire [31:0]PC_plus4M;
    // wire [31:0]U_type_muxout;
    // wire [4:0] RdM;
    // wire RegWriteM;
    wire [1:0]resultSrcM;
    wire MemWriteM;
    
    mux2_1              comp10(JumpRE,PC_nowE,Read_data1E,PC_jump);
    mux2_1              comp11(UIPC_addE,NonUSrc,PC_nowE,SrcAE); 
    mux2_1              comp12(ALUSrcE,WriteDataE,ImmExtE,SrcBE);
    mux4_1              comp13(ForwardAE,Read_data1E,result,ALU_outM,32'd0,NonUSrc);
    mux4_1              comp14(ForwardBE,Read_data2E,result,ALU_outM,32'd0,WriteDataE);
    alu                 comp15(ALUCtrlE,SrcAE,SrcBE,ALU_outE);
    and                 comp16(branch_valid,BranchE,ALU_outE[0]);
    or                  comp17(PCSrcE,branch_valid,JumpE);
    PC_branch_adder     comp18(PC_jump,ImmExtE,PCTargetE);
    E_to_M_register     comp19(clk,reset,RegWriteE,resultSrcE,MemWriteE,ALU_outE,WriteDataE,RdE,PC_plus4E,ALU_outM,WriteDataM,RdM,PC_plus4M,RegWriteM,resultSrcM,MemWriteM);
    
    //Memory
    wire [31:0]ALU_outW;
    wire [31:0]PC_plus4W;
    wire [31:0]ReadDataW;
    // wire [4:0] RdW;
    wire [1:0] resultSrcW;
    // wire RegWriteW;
    Data_Memory         comp20(clk,ALU_outM, WriteDataM, ReadDataM, MemWriteM);
    M_to_W_register     comp21(clk,reset,RegWriteM,resultSrcM,ALU_outM,ReadDataM,RdM,PC_plus4M,ALU_outW,ReadDataW,RdW,PC_plus4W,RegWriteW,resultSrcW);
    
    // write back
    mux4_1              comp22(resultSrcW,ALU_outW,ReadDataW,PC_plus4W,32'd0,result);
    
    //Hazard unit
    Hazard_unit         comp23(Rs1E,Rs2E,RdM,RdW,RegWriteM,RegWriteW,InstrD[19:15],InstrD[24:20],RdE,resultSrcE[0],PCSrcE,ForwardAE,ForwardBE,StallF,StallD,FlushE,FlushD);
endmodule