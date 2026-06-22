module PC_adder (input [31:0] PC_now, output [31:0] PC_next);
    assign    PC_next = PC_now + 32'd4;
endmodule
