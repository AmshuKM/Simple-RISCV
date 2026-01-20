`timescale 1ns/1ps
module data_mem (
    input        clk,
    input        we,
    input        re,
    input [31:0] addr,
    input [31:0] wd,
    output reg [31:0] rd
);

    reg [31:0] mem [0:255];

    always @(posedge clk) begin
        if (we)
            mem[addr[9:2]] <= wd;
    end

    always @(*) begin
        if (re)
            rd = mem[addr[9:2]];
        else
            rd = 32'b0;
    end

endmodule
