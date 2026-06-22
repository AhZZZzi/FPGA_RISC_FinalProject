
module Control_Unit ( 
                    input [6:0]opcode,
                    input [2:0]funct3,
                    input [6:0]funct7,
                    output reg UIPC_add,
                    output reg JumpR,
                    output reg jump,
                    output reg branch,
                    output reg RegWrite,
                    output reg MemWrite,
                    output reg ALUSrc,
                    output reg [1:0]resultSrc,
                    output reg [4:0]ALUCtrl,
                    output reg [2:0]ImmSrc);
    
    `include "def.v"
    
    always @( opcode or funct3 or funct7)
    begin
        case (opcode)
            7'b0110011: //R type
            begin
                RegWrite = 1;
                ImmSrc   = 3'bxxx;
                ALUSrc   = 0;
                MemWrite = 0;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                if (funct7[5]==1'b1 && funct3 == 3'b000)
                begin
                    $display("Sub\n");
                    ALUCtrl = `ALU_SUB;
                end
                else if(funct7[5]==0 && funct3 == 3'b000)
                begin
                    $display("Add\n");
                    ALUCtrl = `ALU_ADD;
                end
                else if(funct7[5]==0 && funct3 == 3'b001)
                begin
                    $display("SLL\n");
                    ALUCtrl = `ALU_SHIFTL;
                end
                else if(funct7[5]==0 && funct3 == 3'b010)
                begin
                    $display("SLT\n");
                    ALUCtrl = `ALU_LESS_THAN_SIGNED;
                end
                else if(funct7[5]==0 && funct3 == 3'b011)
                begin
                    $display("SLTU\n");
                    ALUCtrl = `ALU_LESS_THAN;
                end
                else if(funct7[5]==0 && funct3 == 3'b100)
                begin
                    $display("XOR\n");
                    ALUCtrl = `ALU_XOR;
                end
                else if(funct7[5]==0 && funct3 == 3'b101)
                begin
                    $display("SRL\n");
                    ALUCtrl = `ALU_SHIFTR;
                end
                else if(funct7[5]==1 && funct3 == 3'b101)
                begin
                    $display("SRA\n");
                    ALUCtrl = `ALU_SHIFTR_ARITH;
                end
                else if(funct7[5]==0 && funct3 == 3'b110)
                begin
                    $display("OR\n");
                    ALUCtrl = `ALU_OR;
                end
                else if(funct7[5]==0 && funct3 == 3'b111)
                begin
                    $display("AND\n");
                    ALUCtrl = `ALU_AND;
                end
            end
            7'b0010011: //I type
            begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemWrite = 0;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                if( funct3 == 3'b000)
                begin
                    ImmSrc   = 3'b000;
                    $display("AddI\n");
                    ALUCtrl = `ALU_ADD;
                end
                else if(funct3 == 3'b001)
                begin
                    ImmSrc   = 3'b101;
                    $display("SLLI\n");
                    ALUCtrl = `ALU_SHIFTL;
                end
                else if(funct3 == 3'b010)
                begin
                    ImmSrc   = 3'b000;
                    $display("SLTI\n");
                    ALUCtrl = `ALU_LESS_THAN_SIGNED;
                end
                else if(funct3 == 3'b011)
                begin
                    ImmSrc   = 3'b000;
                    $display("SLTIU \n");
                    ALUCtrl = `ALU_LESS_THAN;
                end
                else if(funct3 == 3'b100)
                begin
                    ImmSrc   = 3'b000;
                    $display("XORI\n");
                    ALUCtrl = `ALU_XOR;
                end
                else if(funct7[5]==0 && funct3 == 3'b101)
                begin
                    ImmSrc   = 3'b101;
                    $display("SRLI\n");
                    ALUCtrl = `ALU_SHIFTR;
                end
                else if(funct7[5]==1 && funct3 == 3'b101)
                begin
                    ImmSrc   = 3'b101;
                    $display("SRAI\n");
                    ALUCtrl = `ALU_SHIFTR_ARITH;
                end
                else if(funct3 == 3'b110)
                begin
                    ImmSrc   = 3'b000;
                    $display("ORI\n");
                    ALUCtrl = `ALU_OR;
                end
                else if(funct3 == 3'b111)
                begin
                    ImmSrc   = 3'b000;
                    $display("AND\n");
                    ALUCtrl = `ALU_AND;
                end
            end
            7'b0000011: //lw
            begin 
                RegWrite = 1;
                ImmSrc   = 3'b000;
                ALUSrc   = 1;
                MemWrite = 0;
                resultSrc= 2'b01;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                ALUCtrl  = `ALU_ADD;
                $display("Load\n");
            end
            7'b0100011: //sw
            begin 
                RegWrite = 0;
                ImmSrc   = 3'b001; 
                ALUSrc   = 1;
                MemWrite = 1;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                ALUCtrl  = `ALU_ADD;
                $display("Store\n");
            end
            7'b1100011: //branch
            begin 
                RegWrite = 0;
                ImmSrc   = 3'b010; 
                ALUSrc   = 0;
                MemWrite = 0;
                resultSrc= 2'bxx;
                branch   = 1;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                if (funct3 == 3'b000)
                    begin
                        ALUCtrl  = `ALU_EQUAL;
                        $display("BEQ\n");
                    end
                else if (funct3 == 3'b001)
                    begin
                        ALUCtrl  = `ALU_NOT_EQUAL;
                        $display("BNE\n");
                    end
                else if (funct3 == 3'b100)
                    begin
                        ALUCtrl  = `ALU_LESS_THAN_SIGNED;
                        $display("BLT\n");
                    end
                else if (funct3 == 3'b101)
                    begin
                        ALUCtrl  = `ALU_GREATER_THAN_OR_EQUAL_SIGNED;
                        $display("BGE\n");
                    end
                else if (funct3 == 3'b110)
                    begin 
                        ALUCtrl  = `ALU_LESS_THAN;
                        $display("BLTU\n");
                    end
                else if (funct3 == 3'b111)
                    begin
                        ALUCtrl  = `ALU_GREATER_THAN_OR_EQUAL;
                        $display("BGEU\n");
                    end
            end
            7'b1101111: //jal
            begin 
                RegWrite = 1;
                ImmSrc   = 3'b011; 
                ALUSrc   = 1'bx;
                MemWrite = 0;
                resultSrc= 2'b10;
                branch   = 0;
                jump     = 1;
                JumpR    = 0;
                UIPC_add = 0;
                ALUCtrl  = 5'bxxxxx;
                $display("JAL\n");
            end
            
            7'b1100111: //jalr
            begin
                RegWrite = 1;
                ImmSrc   = 3'b011; 
                ALUSrc   = 1'bx;
                MemWrite = 0;
                resultSrc= 2'b10;
                branch   = 0;
                jump     = 1;
                JumpR    = 1;
                UIPC_add = 0;
                ALUCtrl  = 5'bxxxxx;
                $display("JALR\n");
            end
            
            7'b0110111: //LUI 
            begin
                RegWrite = 1;
                ImmSrc   = 3'b100;
                ALUSrc   = 1;
                MemWrite = 0;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                ALUCtrl  = `ALU_LOAD_UPPER;
            end
            
            7'b0010111: //AUIPC
            begin 
                RegWrite = 1;
                ImmSrc   = 3'b100;
                ALUSrc   = 1;
                MemWrite = 0;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 1;
                ALUCtrl  = `ALU_ADD;
            end
            
            default: 
            begin 
                RegWrite = 0;
                ImmSrc   = 3'b000; 
                ALUSrc   = 1'b0;
                MemWrite = 0;
                resultSrc= 2'b00;
                branch   = 0;
                jump     = 0;
                JumpR    = 0;
                UIPC_add = 0;
                ALUCtrl  = `ALU_NONE;
            end
        endcase
    end
endmodule