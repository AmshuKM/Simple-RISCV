`timescale 1ns/1ps
module imm_gen (
    input  [31:0] instr,
    output reg [31:0] imm
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)

            // I-type: ADDI, LW
            7'b0010011,
            7'b0000011: begin
                imm = {{20{instr[31]}}, instr[31:20]};
            end

            // S-type: SW
            7'b0100011: begin
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end
            
            7'b0110111: begin // LUI
    		imm = {instr[31:12], 12'b0};
	    end
	    
	    7'b1100011: begin // BEQ (B-type)
    imm = {{19{instr[31]}},
           instr[31],
           instr[7],
           instr[30:25],
           instr[11:8],
           1'b0};
	end



            default: begin
                imm = 32'b0;
            end

        endcase
    end

endmodule
