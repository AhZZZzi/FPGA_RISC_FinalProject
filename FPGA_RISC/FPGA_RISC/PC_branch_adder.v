module PC_branch_adder (
                        input [31:0]PC_now,
                        input [31:0]ImmExt,
                        output[31:0]PCTarget);
    assign    PCTarget = PC_now + ImmExt;
endmodule