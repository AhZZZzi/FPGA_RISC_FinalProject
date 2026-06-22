module generate_clk(input clk, output reg gen_clk);
reg [24:0] counter;
initial begin
    counter = 0;
    gen_clk = 1;
end
always @(negedge clk) begin
    if (counter == 0) begin
        counter <= 24999999;
        gen_clk <= ~gen_clk;
    end else begin
        counter <= counter -1;
    end
end
endmodule