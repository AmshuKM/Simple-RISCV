`timescale 1ns/1ps
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  op,
    output reg [31:0] y
);

always @(*) begin
    case (op)
        3'b000: y = a + b;          // ADD, ADDI, LW, SW
        3'b001: y = a - b;          // SUB, BEQ, BNE
        3'b010: y = a & b;          // AND
        3'b011: y = a | b;          // OR
        3'b100: y = a ^ b;          // XOR
        3'b101: y = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (signed)
        default: y = 0;
    endcase
end


endmodule
