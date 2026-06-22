module mux2_1 (input sel, input [31:0] in1, input [31:0] in2, output [31:0] mux_out);
    assign mux_out = sel ? (in2):(in1);
endmodule