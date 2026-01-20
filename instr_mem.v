module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);

    reg [7:0] mem [0:4095]; // byte-addressable
    integer i;

    initial begin
        // Initialize all memory to NOP (0x00000013)
        for (i = 0; i < 4096; i = i + 4) begin
            mem[i+0] = 8'h13;
            mem[i+1] = 8'h00;
            mem[i+2] = 8'h00;
            mem[i+3] = 8'h00;
        end

        // Load program (overwrites beginning)
        $readmemh("program.hex", mem);
    end

    assign instr = {
        mem[addr + 3],
        mem[addr + 2],
        mem[addr + 1],
        mem[addr + 0]
    };

endmodule
