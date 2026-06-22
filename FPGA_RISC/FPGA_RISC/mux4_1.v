module mux4_1 (
                input [1:0]sel, 
                input [31:0] in1,
                input [31:0] in2,
                input [31:0] in3,
                input [31:0] in4,
                output [31:0] mux_out);
    assign mux_out = sel[1] ?(sel[0]?in4:in3) :(sel[0]?in2:in1);
endmodule