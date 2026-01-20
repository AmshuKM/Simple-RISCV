module rv32_core (
    input  wire        clk,
    input  wire        reset,

    // ---- ZKP-observable architectural signals ----
    output wire [31:0] pc,
    output wire [31:0] pc_next,
    output wire [31:0] rs1_val,
    output wire [31:0] rs2_val,
    output wire [31:0] imm,
    output wire        is_beq,
    output wire        is_bne
);

    // -------------------------
    // PC
    // -------------------------
    reg [31:0] pc_reg;
    assign pc = pc_reg;

    // -------------------------
    // Instruction memory (dummy / simple)
    // -------------------------
    // For demo: hardcoded instruction behavior
    // You can replace this with real instr_mem later

    // -------------------------
    // Register file (simple)
    // -------------------------
    reg [31:0] regfile [0:31];

    assign rs1_val = regfile[1];   // x1
    assign rs2_val = regfile[2];   // x2

    // -------------------------
    // Immediate + control (example)
    // -------------------------
    // Example behavior:
    // pc=8  : BNE x1,x2,+8
    // pc=16 : BEQ x1,x1,+4
    // pc=20 : NOP

    assign is_beq = (pc_reg == 32'd16);
    assign is_bne = (pc_reg == 32'd8);

    assign imm =
        (pc_reg == 32'd8)  ? 32'd8 :
        (pc_reg == 32'd16) ? 32'd4 :
                             32'd4;

    wire eq = (rs1_val == rs2_val);

    // -------------------------
    // Next PC logic
    // -------------------------
    assign pc_next =
        (is_beq && eq)  ? pc_reg + imm :
        (is_bne && !eq) ? pc_reg + imm :
                          pc_reg + 32'd4;

    // -------------------------
    // Sequential logic
    // -------------------------
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            pc_reg <= 32'd8;   // start at PC=8 (matches your trace)

            // init registers
            for (i = 0; i < 32; i = i + 1)
                regfile[i] <= 32'd0;

            regfile[1] <= 32'd5; // x1 = 5
            regfile[2] <= 32'd6; // x2 = 6

        end else begin
            pc_reg <= pc_next;
        end
    end

endmodule
