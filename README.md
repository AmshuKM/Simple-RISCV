## Simple-RISCV
A simple RV32I RISC-V processor core implemented from scratch for learning and experimentation. Includes RTL design, testbenches, and simulation setup.


# RISC-V RV32I Processor Core

This repository contains a modular Verilog implementation of a simplified RV32I RISC-V processor.
The design includes the fundamental building blocks of a single-cycle CPU architecture such as an ALU, control unit, register file, immediate generator, instruction memory, data memory, and a top-level core.
The project is structured for learning, simulation, and future extensions (pipeline stages, forwarding, hazard detection, ZKP-friendly tracing, etc.).

## 📂 Included Modules
# 1. ALU (alu.v)
Implements basic arithmetic operations:
ADD
SUB
(Extendable for AND, OR, SLT, XOR, shifts)

ALU operation selected via a 3-bit op code.

# 2. Control Unit (control.v)
Generates control signals based on:
opcode
funct3
funct7

Supports:
R-type (ADD, SUB)
I-type (ADDI)
Load (LW)
Store (SW)
LUI
Branch (BEQ, BNE)

# 3. Immediate Generator (imm_gen.v)
Generates sign-extended immediate values for:
I-type
S-type
B-type
U-type

# 4. Register File (regfile.v)
32 general-purpose registers
Synchronous write, asynchronous read
x0 hardwired to zero

# 5. Instruction Memory (instr_mem.v)
Byte-addressable memory
Loads program from program.hex
Default initialization to NOP (0x00000013)

# 6. Data Memory (data_mem.v)
Supports LW and SW
Byte indexing via addr[9:2] (word-aligned)

# 7. Top-Level Core (rv32_core.v / rv32_single_cycle.v)
A minimal single-cycle-like implementation with:
Program counter
Basic branch logic
Tracked architectural signals for ZKP workflows
pc, pc_next
rs1_val, rs2_val
imm
is_beq, is_bne

This top-level can be swapped with a full instruction decode + datapath module later.
