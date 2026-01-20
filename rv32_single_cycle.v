`timescale 1ns/1ps
module rv32_single_cycle (
    input  wire clk,
    input  wire reset
);

    // -------------------------------
    // Program Counter
    // -------------------------------
    reg [31:0] pc;
    wire [31:0] pc_next;

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;
        else
            pc <= pc_next;
    end

    // -------------------------------
    // Instruction Memory
    // -------------------------------
    wire [31:0] instr;

    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    // -------------------------------
    // Instruction Fields
    // -------------------------------
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    // -------------------------------
    // Control Unit
    // -------------------------------
    wire RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, Branch;
    wire [2:0] ALUOp;

    control cu(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // -------------------------------
    // Register File
    // -------------------------------
    wire [31:0] rd1, rd2;

    regfile rf (
        .clk(clk),
        .we(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // -------------------------------
    // Immediate Generator
    // -------------------------------
    wire [31:0] imm;

    imm_gen ig (
        .instr(instr),
        .imm(imm)
    );

    // -------------------------------
    // ALU input mux
    // -------------------------------
    wire [31:0] alu_in2 = (ALUSrc) ? imm : rd2;

    // -------------------------------
    // ALU
    // -------------------------------
    wire [31:0] alu_result;

    alu alu_u (
        .a(rd1),
        .b(alu_in2),
        .op(ALUOp),
        .y(alu_result)
    );

    // -------------------------------
    // Data Memory
    // -------------------------------
    wire [31:0] mem_out;

    data_mem dmem (
        .clk(clk),
        .we(MemWrite),
        .re(MemRead),
        .addr(alu_result),
        .wd(rd2),
        .rd(mem_out)
    );

    // -------------------------------
    // Writeback Mux
    // -------------------------------
    wire [31:0] wd = (MemToReg) ? mem_out : alu_result;

    // -------------------------------
    // Branch Logic
    // BEQ-only (funct3 = 000)
    // -------------------------------
    wire beq  = (funct3 == 3'b000);
    wire bne  = (funct3 == 3'b001);
    wire blt  = (funct3 == 3'b100);
    wire bge  = (funct3 == 3'b101);

    wire condition =
      (beq & (rd1 == rd2)) |
      (bne & (rd1 != rd2)) |
      (blt & ($signed(rd1) < $signed(rd2))) |
      (bge & ($signed(rd1) >= $signed(rd2)));

    wire take_branch = Branch & condition;


    assign pc_next = (take_branch) ? pc + imm : pc + 4;

endmodule
