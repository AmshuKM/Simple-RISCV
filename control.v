`timescale 1ns/1ps
module control (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg   RegWrite,
    output reg   ALUSrc,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   MemToReg,
    output reg Branch,
    output reg [2:0] ALUOp
);

always @(*) begin
    RegWrite = 0;
    ALUSrc   = 0;
    MemRead  = 0;
    MemWrite = 0;
    MemToReg = 0;
    Branch = 0;
    ALUOp    = 0;

    case (opcode)

        7'b0110011: begin // R-type
            RegWrite = 1;
            case ({funct7, funct3})
                10'b0000000_000: ALUOp = 3'b000; // ADD
                10'b0100000_000: ALUOp = 3'b001; // SUB
                default:         ALUOp = 3'b000;
            endcase
        end

        7'b0010011: begin // ADDI
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 3'b000;
        end

        7'b0000011: begin // LW
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemToReg = 1;
            ALUOp    = 3'b000;
        end

        7'b0100011: begin // STORE (SB/SH/SW)
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 3'b000;
        end
        
        7'b0110111: begin // LUI
    		RegWrite = 1;
    		ALUSrc   = 1;
    		ALUOp    = 3'b000; // ADD
	end
	
	7'b1100011: begin // BEQ
  	  Branch = 1;
  	  ALUSrc = 0;
  	  ALUOp  = 3'b001; // SUB (for comparison)
	end
	
	7'b1100011: begin // Branch instructions
    Branch = 1;
    ALUSrc = 0;
    ALUOp  = 3'b001; // SUB (comparison)
	end


    endcase
end

endmodule
