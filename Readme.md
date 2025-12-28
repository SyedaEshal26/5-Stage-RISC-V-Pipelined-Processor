## **RISC-V Pipelined Processor Design **

---

### **1. INTRODUCTION TO RISC-V PIPELINED PROCESSOR**

---

This project implements a **RISC-V pipelined processor** using **Verilog HDL**.
Pipelining is a technique used to improve processor performance by dividing instruction execution into multiple stages and allowing multiple instructions to be processed simultaneously.

The project demonstrates the **five-stage RISC-V pipeline**, including **Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write-Back (WB)**.

It is intended for learning **advanced computer architecture concepts**, pipelining, and Verilog-based processor design through simulation.

---

### **2. PROJECT STRUCTURE**

---

**RISC-V Pipelined Processor**

```
RISC_V_Pipeline/
├── Design/
│   ├── adder.v
│   ├── alu.v
│   ├── alu_control.v
│   ├── clk_div.v
│   ├── control_unit.v
│   ├── cu.v
│   ├── data_mem.v
│   ├── imm_ext.v
│   ├── inst_memory.v
│   ├── instr_mem.v
│   ├── mux.v
│   ├── pc.v
│   ├── reg_file.v
│   ├── risc_v_pipeline.v
│   ├── IF_pipe.v
│   ├── ID_pipe.v
│   ├── EX_pipe.v
│   ├── MEM_pipe.v
│   └── WB_pipe.v
├── Testbench/
│   └── risc_v_pipeline_tb.v
└── README.md
```

---

### **3. MODULES**

---

#### **1. IF_ID.v (Instruction Fetch Stage)**

This module implements the **Instruction Fetch (IF) stage** of the pipeline.

* Fetches the instruction from instruction memory.
* Updates the Program Counter (PC).
* Passes instruction and PC values to the ID stage through pipeline registers.

---

#### **2. ID_EX.v (Instruction Decode Stage)**

This module implements the **Instruction Decode (ID) stage**.

* Decodes the fetched instruction.
* Reads source registers from the register file.
* Generates immediate values.
* Produces control signals for later stages.

---

#### **3. EX_MEM.v (Execute Stage)**

This module implements the **Execute (EX) stage**.

* Performs arithmetic and logical operations using the ALU.
* Calculates branch and memory addresses.
* Selects operands using multiplexers.

---

#### **4. MEM_WB.v (Memory Access Stage)**

This module implements the **Memory Access (MEM) stage**.

* Handles data memory read and write operations.
* Executes load and store instructions.
* Passes results to the Write-Back stage.

---

#### **6. alu.v**

This module implements the **Arithmetic Logic Unit (ALU)**.

* Performs arithmetic and logical operations:

  * Addition
  * Subtraction
  * AND, OR, XOR
* Controlled by ALU control signals.

---

#### **7. alu_control.v**

This module generates **ALU control signals**.

* Decodes instruction function fields.
* Determines the ALU operation for the Execute stage.

---

#### **8. control_unit.v**

This module implements the **main control unit**.

* Decodes instruction opcodes.
* Generates control signals for all pipeline stages.
* Manages instruction execution flow.

---

#### **9. reg_file.v**

This module implements the **RISC-V register file**.

* Contains 32 general-purpose registers.
* Supports:

  * Two read ports
  * One write port
* Register x0 is hardwired to zero.

---

#### **10. pc.v**

This module implements the **Program Counter (PC)**.

* Holds the address of the current instruction.
* Updates every clock cycle.
* Supports sequential instruction execution.

---

#### **11. imm_ext.v**

This module implements the **Immediate Extension Unit**.

* Extracts and sign-extends immediate fields.
* Supports multiple RISC-V instruction formats.

---

#### **12. data_mem.v**

This module implements **data memory**.

* Used during the MEM stage.
* Supports load and store instructions.

---

#### **13. mux.v**

This module implements **multiplexers** used throughout the pipeline.

* Selects appropriate operands and data paths.
* Controlled by control signals.

---

#### **14. risc_v_pipeline.v**

This is the **top-level module** of the RISC-V pipelined processor.

* Integrates all pipeline stages:

  * IF
  * ID
  * EX
  * MEM
  * WB
* Coordinates data and control flow across the pipeline.

---

#### **15. risc_v_pipeline_tb.v**

This module is the **testbench** for the RISC-V pipelined processor.

* Generates clock and test signals.
* Verifies pipelined execution.
* Used for simulation and debugging.

---

## **4. GETTING STARTED**

---

```
git clone https://github.com/your-username/RISC_V_Pipeline.git
cd RISC_V_Pipeline
```

---

## **5. USAGE**

---

1. Open **ModelSim / Quartus Prime / Vivado**.
2. Create a new project.
3. Add all Verilog files from **Design** and **Testbench** folders.
4. Compile the design.
5. Run the testbench (*risc_v_pipeline_tb.v*).
6. Observe pipeline waveforms and execution behavior.

---

## **6. CONTRIBUTING**

---

If you would like to contribute to this project, please fork the repository and submit a pull request.

---

---