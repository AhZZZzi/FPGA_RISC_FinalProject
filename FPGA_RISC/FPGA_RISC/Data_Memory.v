module Data_Memory (clk,addr, write_data, read_data, MemWrite);
    input [31:0] addr;
    input [31:0] write_data;
    output [31:0] read_data;
    input  MemWrite,clk;
    reg MemRead = 1;
    reg [31:0] DMemory [63:0];
    integer k;
    initial begin
        for (k=0; k<64; k=k+1)
            begin
                DMemory[k] = 32'b0;
            end
        end
    assign read_data = (MemRead) ? DMemory[addr] : 32'bx;
    
    always @(negedge clk)
        begin
            if (MemWrite) DMemory[addr] = write_data;
        end
endmodule
