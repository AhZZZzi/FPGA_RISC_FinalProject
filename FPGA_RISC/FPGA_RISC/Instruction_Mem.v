module Instruction_Memory ( input [31:0] read_address, output [31:0] instruction);
	reg [31:0] Imemory [255:0];
	integer k;
	// I-MEM in this case is addressed by word, not by byte
	assign instruction = Imemory[read_address];
	initial
	begin
	    for (k=0; k<256; k=k+1) 
            begin  
			      Imemory[k] = 32'b0;
			end
		   	//addi x18,x0,0x01
        Imemory[0]=32'b0000_0000_0001_00000_000_10010_0010011;
        //addi x19,x0,0x03
        Imemory[4]=32'b0000_0000_0011_00000_000_10011_0010011;
        //add x20,x20,x18
        Imemory[8]=32'b0000000_10100_10010_000_10100_0110011;
        //sw x20,0x03(x18)
        Imemory[12]=32'b0000000_10100_10010_010_00011_0100011;
        //lw x21,0x03(x18)
        Imemory[16]=32'b0000_0000_0011_10010_010_10101_0000011;
        //beq x19,x21, 0x1C
        Imemory[20]=32'b0000000_10101_10011_000_01100_1100011;
        //jalr x1,x0,0x08
        Imemory[24]=32'b0000_0000_1000_00000_000_00001_1100111;
        //lw x21,0x03(x18)
        Imemory[28]=32'b0000_0000_0011_10010_010_10101_0000011;
        //jalr x1,x0,0x20        
        Imemory[32]=32'b0000_0010_0000_00000_000_00001_1100111;
         
    end
endmodule