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

    // -------- R-TYPE --------
    7'b0110011: begin
        RegWrite = 1;
        ALUSrc   = 0;

        case (funct3)
            3'b000: ALUOp = (funct7 == 7'b0100000) ? 3'b001 : 3'b000; // SUB : ADD
            3'b100: ALUOp = 3'b100;  // XOR
            3'b110: ALUOp = 3'b011;  // OR
            3'b111: ALUOp = 3'b010;  // AND
            3'b010: ALUOp = 3'b101;  // SLT (for BLT/BGE too)
            default: ALUOp = 3'b000;
        endcase
    end

    // -------- I-TYPE (ADDI, XORI, ORI, ANDI) --------
    7'b0010011: begin
        RegWrite = 1;
        ALUSrc   = 1;

        case (funct3)
            3'b000: ALUOp = 3'b000; // ADDI
            3'b100: ALUOp = 3'b100; // XORI
            3'b110: ALUOp = 3'b011; // ORI
            3'b111: ALUOp = 3'b010; // ANDI
            default: ALUOp = 3'b000;
        endcase
    end

    // -------- LW --------
    7'b0000011: begin
        RegWrite = 1;
        ALUSrc   = 1;
        MemRead  = 1;
        MemToReg = 1;
        ALUOp    = 3'b000;
    end

    // -------- SW --------
    7'b0100011: begin
        ALUSrc   = 1;
        MemWrite = 1;
        ALUOp    = 3'b000;
    end

    // -------- LUI --------
    7'b0110111: begin
        RegWrite = 1;
        ALUSrc   = 1;
        ALUOp    = 3'b000;
    end

    // -------- BRANCHES --------
    7'b1100011: begin
        Branch = 1;
        ALUSrc = 0;

        case (funct3)
            3'b000: ALUOp = 3'b001; // BEQ = SUB
            3'b001: ALUOp = 3'b001; // BNE = SUB
            3'b100: ALUOp = 3'b101; // BLT = SLT
            3'b101: ALUOp = 3'b101; // BGE = SLT
            default: ALUOp = 3'b001;
        endcase
    end

endcase
end

endmodule
