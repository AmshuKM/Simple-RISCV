`timescale 1ns/1ps

module tb_single_cycle;

    reg clk;
    reg reset;

    // Instantiate DUT
    rv32_single_cycle dut (
        .clk(clk),
        .reset(reset)
    );

    // ---------------
    // Clock generation
    // ---------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10ns period → 100 MHz
    end

    // ---------------
    // Reset + Program Load
    // ---------------
    initial begin
        reset = 1;

        // Let clock run a bit
        #20;
        reset = 0;
    end

    // ---------------
    // Simulation control + debug
    // ---------------
    initial begin
        // waveform dumping
        $dumpfile("single_cycle.vcd");
        $dumpvars(0, tb_single_cycle);

        // Console banner
        $display("----------------------------------------------");
        $display("   Single-Cycle RV32I CPU Simulation Started   ");
        $display("----------------------------------------------");

        // Print header
        $display("Time\tPC\tInstr\tALU Result");

        // Let the CPU run for a while
        #3000;

        $display("\nSimulation complete.");
        $finish;
    end

    // ---------------
    // DEBUG MONITOR (important!)
    // ---------------
    always @(posedge clk) begin
        // Print PC + Instruction + ALU/Memory data
        $display("%0dns\tPC=%h  Instr=%h  ALU=%h",
                 $time,
                 dut.pc,
                 dut.instr,
                 dut.alu_result);
    end

endmodule
