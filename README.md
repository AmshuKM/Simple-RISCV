# 🧠 Simple-RISCV — A Minimal RV32I RISC-V CPU (Single-Cycle)

A clean and modular **RV32I RISC-V processor core** implemented entirely in Verilog for learning, experimentation, and CPU architecture exploration.  
This project includes a fully working **single-cycle** CPU, complete with datapath components, control logic, instruction/data memories, and simulation testbenches.

This is designed as a beginner-friendly but structurally accurate CPU, suitable for:
- Computer architecture learning  
- RTL design practice  
- FPGA experimentation (future work)  
- Extending into a pipelined CPU  
- Zero-Knowledge Proof (ZKP) hardware modeling  

---

## 📐 CPU Architecture Overview

Below is the block-level flow of the single-cycle RV32I core:

!RISCV FLOW.png

---

## 📂 Included Modules

### **1. ALU (`alu.v`)**
Implements arithmetic & logic operations:
- ADD, SUB  
- AND, OR, XOR  
- SLT (signed compare)  
- Extendable to shifts & more RV32I ops  
- `ALUOp` selects the operation

---

### **2. Control Unit (`control.v`)**
Generates control signals based on:
- `opcode`, `funct3`, `funct7`

Supports:
- **R-type:** ADD, SUB, AND, OR, XOR, SLT  
- **I-type:** ADDI, ANDI, ORI, XORI  
- **Load:** LW  
- **Store:** SW  
- **LUI**  
- **Branches:** BEQ, BNE, BLT, BGE  

Outputs:
- `RegWrite`, `ALUSrc`, `MemRead`,  
  `MemWrite`, `MemToReg`, `Branch`, `ALUOp`

---

### **3. Immediate Generator (`imm_gen.v`)**
Decodes immediates for:
- **I-type**  
- **S-type**  
- **B-type**  
- **U-type**  
Fully sign-extended per RV32I spec.

---

### **4. Register File (`regfile.v`)**
- 32 registers (x0–x31)  
- Synchronous write  
- Asynchronous read  
- `x0` hardwired to zero  

---

### **5. Instruction Memory (`instr_mem.v`)**
- Byte-addressable  
- Loads program from `program.hex`  
- Uninitialized bytes default to NOP (`0x00000013`)  

---

### **6. Data Memory (`data_mem.v`)**
- Supports LW and SW  
- Word-aligned addressing (`addr[9:2]`)  
- Simple behavioral RAM  

---

### **7. Single-Cycle Core (`rv32_single_cycle.v`)**
Implements:
- Program Counter  
- Instruction Fetch  
- Register Read  
- Immediate Decode  
- ALU  
- Memory Access  
- Write-Back  
- Branch decision logic  

Fully compatible with your other RTL modules.

---

## ▶️ Simulation & Usage

### **1. Compile with Icarus Verilog**
```bash
iverilog -o cpu \
  tb_single_cycle.v \
  rv32_single_cycle.v \
  alu.v control.v regfile.v imm_gen.v instr_mem.v data_mem.v
vvp cpu
gtkwave single_cycle.vcd
```


### **2. Program Loading (program.hex)**

The CPU fetches instructions from instr_mem using:

$readmemh("program.hex", mem);


The file must contain 1 byte per line in little-endian order.

Example:
``` bash
93
00
00
00    # addi x1, x0, 0
```

You can generate this from C or assembly using the RISC-V toolchain.




## Acknowledgements

Thanks to the RISC-V community, open-source hardware researchers, and classic architecture texts (Patterson & Hennessy).
