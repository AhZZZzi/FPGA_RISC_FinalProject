module extend (
                input [2:0]ImmSrc,
                input [24:0] Imm, 
                output reg [31:0] ImmExt);
    always @(ImmSrc or Imm)
    begin
    case (ImmSrc)
        3'b000: //lw
        begin
            ImmExt = {{20{Imm[24]}}, Imm[24:13]};
        end
        3'b001: //sw
        begin
            ImmExt = {{20{Imm[24]}}, Imm[24:18],Imm[4:0]};
        end
        3'b010: //beq
        begin
            ImmExt =  {{20{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};
        end
        3'b011: //jal
        begin
            ImmExt = {{12{Imm[24]}}, Imm[12:5], Imm[13],Imm[23:14], 1'b0};
        end
        3'b100: //LUI/AUIPC
        begin
            ImmExt = {Imm[24:5], 12'b0};
        end
        3'b101: //Shamt 
        begin   
            ImmExt = {27'd0,Imm[17:13]};
        end
        default:
            ImmExt = 32'd0;
    endcase
    end
endmodule