module Fetch_stage (//input 
                    input clk,
                    input reset,
                    input StallF,
                    input [31:0] PCTargetE,
                    input PCSrcE,
                    //output
                    output [31:0]PC_next,
                    output [31:0] Instr,
                    output [31:0] PC_now,
                    output [31:0] PC_plus4);
                    
    // wire [31:0]PC_next;
    
    Program_Counter     comp1 (clk, reset , StallF ,PC_next, PC_now);
    PC_adder            comp2 (PC_now,PC_plus4);
    Instruction_Memory  comp3 (PC_now,Instr);
    mux2_1              comp4 (PCSrcE,PC_plus4,PCTargetE,PC_next);
endmodule