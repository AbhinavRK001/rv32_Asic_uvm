<div align="center">

# ⚡ RV32I ASIC CORE

### 32-bit RISC-V Processor • SystemVerilog • UVM • RTL-to-GDSII

**A from-scratch RV32I processor being developed from microarchitecture → RTL → verification → physical implementation.**

<br>

![SystemVerilog](https://img.shields.io/badge/RTL-SystemVerilog-blue?style=for-the-badge)
![RISC-V](https://img.shields.io/badge/ISA-RV32I-purple?style=for-the-badge)
![UVM](https://img.shields.io/badge/Verification-UVM-orange?style=for-the-badge)
![ASIC](https://img.shields.io/badge/Target-ASIC-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-IN%20DEVELOPMENT-yellow?style=for-the-badge)

<br>

`RTL` → `Verification` → `Synthesis` → `Physical Design` → `Signoff` → `GDSII`

</div>

---

# 🧠 What is this?

This repository documents the development of a **32-bit RISC-V processor from scratch in SystemVerilog**.

The project begins with a functional RV32I datapath and will progressively evolve into a:

> **5-stage pipelined RV32I processor with hazard handling, forwarding, SystemVerilog/UVM verification, and a complete ASIC RTL-to-GDSII implementation flow.**

The goal is not simply to make a processor that simulates.

The goal is to understand and implement the **complete digital IC design flow**.

---

# 🏗️ Processor Architecture

```text
                           RV32I CORE
                               │
                               ▼
                     ┌─────────────────┐
                     │ Program Counter │
                     └────────┬────────┘
                              │
                              ▼
                     ┌─────────────────┐
                     │   Instruction   │
                     │     Memory      │
                     └────────┬────────┘
                              │ instruction
                              ▼
                     ┌─────────────────┐
                     │     Decoder     │
                     └───────┬─────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
       ┌────────────────┐        ┌────────────────┐
       │ Register File  │        │ Immediate Gen  │
       │    32 × 32     │        │                │
       └───────┬────────┘        └───────┬────────┘
               │                         │
               │ read_data2              │ imm
               └────────────┬────────────┘
                            ▼
                       ┌─────────┐
                       │ ALU MUX │ ◄──── ALUSrc
                       └────┬────┘
                            │
          read_data1 ───────┤
                            ▼
                       ┌─────────┐
                       │   ALU   │ ◄──── ALUOp
                       └────┬────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Data Memory  │
                    └───────┬───────┘
                            │
                            ▼
                        Writeback
```

---

# 🚦 Current Development Status

| Component | Status |
|:---|:---:|
| Program Counter | ✅ |
| Instruction Memory | ✅ |
| Register File | ✅ |
| Instruction Decoder | ✅ |
| ALU | ✅ |
| ALU Operand MUX | ✅ |
| Immediate Generator | 🚧 |
| Data Memory | 🚧 |
| Writeback | ⏳ |
| Branch / Jump Logic | ⏳ |
| Single-Cycle Integration | ⏳ |
| 5-Stage Pipeline | ⏳ |
| Forwarding Unit | ⏳ |
| Hazard Detection | ⏳ |
| UVM Verification | ⏳ |
| Logic Synthesis | ⏳ |
| Physical Design | ⏳ |
| GDSII | ⏳ |

> `✅ Complete` &nbsp;&nbsp; `🚧 In Progress` &nbsp;&nbsp; `⏳ Planned`

---

# ⚙️ ALU

The current ALU supports:

| ALUOp | Operation | RISC-V |
|:---:|:---:|:---:|
| `0000` | `A + B` | ADD / ADDI |
| `0001` | `A - B` | SUB |
| `0010` | `A & B` | AND / ANDI |
| `0011` | `A \| B` | OR / ORI |
| `0100` | `A ^ B` | XOR / XORI |
| `0101` | `A << B` | SLL |
| `0110` | `A >> B` | SRL |
| `0111` | `A >>> B` | SRA |

<details>
<summary><b>🔎 How is the ALU controlled?</b></summary>

<br>

The instruction decoder extracts:

```text
opcode
funct3
funct7
```

and generates:

```text
RegWrite
MemRead
MemWrite
ALUSrc
Branch
Jump
ALUOp
```

For example:

```text
ADD x5, x1, x2

opcode = 0110011
funct3 = 000
funct7 = 0000000

            ↓

ALUSrc  = 0
RegWrite = 1
ALUOp   = 0000

            ↓

ALU → read_data1 + read_data2
```

</details>

---

# 📜 Instruction Support

<details open>
<summary><b>🟣 R-Type Instructions</b></summary>

<br>

- [x] ADD
- [x] SUB
- [x] AND
- [x] OR
- [x] XOR
- [x] SLL
- [x] SRL
- [x] SRA

</details>

<details>
<summary><b>🔵 I-Type Instructions</b></summary>

<br>

- [x] ADDI
- [x] ANDI
- [x] ORI
- [x] XORI
- [ ] SLTI
- [ ] SLTIU
- [ ] SLLI
- [ ] SRLI
- [ ] SRAI
- [ ] LW
- [ ] JALR

</details>

<details>
<summary><b>🟢 Memory / Branch / Jump</b></summary>

<br>

### Load / Store

- [ ] LW
- [ ] SW

### Branch

- [ ] BEQ
- [ ] BNE
- [ ] BLT
- [ ] BGE
- [ ] BLTU
- [ ] BGEU

### Jump

- [ ] JAL
- [ ] JALR

### Upper Immediate

- [ ] LUI
- [ ] AUIPC

</details>

---

# 🚀 Target Microarchitecture

The final processor will use the classic:

## **5-Stage RISC-V Pipeline**

```text
     IF          ID          EX          MEM         WB

┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐
│  FETCH  │→│ DECODE  │→│ EXECUTE │→│ MEMORY  │→│WRITEBACK│
└─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘
     │           │           │           │
     ▼           ▼           ▼           ▼
   IF/ID       ID/EX       EX/MEM       MEM/WB
```

The pipeline will eventually include:

- Data forwarding
- RAW hazard detection
- Load-use stalls
- Branch flushing
- Control-hazard handling

---

# 🧪 Verification

Verification will be developed alongside the RTL rather than added only after the CPU is complete.

```text
Directed SystemVerilog TB
           │
           ▼
Self-Checking Testbench
           │
           ▼
Randomized Verification
           │
           ▼
Assertions + Coverage
           │
           ▼
        UVM
           │
           ▼
   CPU-Level Verification
```

<details>
<summary><b>🧪 Planned UVM Environment</b></summary>

<br>

```text
              ┌──────────────┐
              │   Sequence   │
              └──────┬───────┘
                     ▼
              ┌──────────────┐
              │  Sequencer   │
              └──────┬───────┘
                     ▼
              ┌──────────────┐
              │    Driver    │
              └──────┬───────┘
                     ▼
              ┌──────────────┐
              │     DUT      │
              │  RV32 CORE   │
              └──────┬───────┘
                     ▼
              ┌──────────────┐
              │   Monitor    │
              └──────┬───────┘
                     │
              ┌──────┴───────┐
              ▼              ▼
        ┌──────────┐   ┌──────────┐
        │Scoreboard│   │ Coverage │
        └──────────┘   └──────────┘
```

### Verification roadmap

- [ ] Module-level directed tests
- [ ] Self-checking testbenches
- [ ] Constrained random testing
- [ ] Assertions
- [ ] Functional coverage
- [ ] UVM sequences
- [ ] UVM driver
- [ ] UVM monitor
- [ ] UVM scoreboard
- [ ] CPU-level regression

</details>

---

# 🏭 ASIC Flow

The completed RTL will be taken through a full **RTL-to-GDSII flow**.

```text
                  SystemVerilog RTL
                         │
                         ▼
                 RTL Verification
                         │
                         ▼
                  Logic Synthesis
                         │
                         ▼
                 Gate-Level Netlist
                         │
                         ▼
                    Floorplanning
                         │
                         ▼
                   Power Planning
                         │
                         ▼
                      Placement
                         │
                         ▼
               Clock Tree Synthesis
                         │
                         ▼
                       Routing
                         │
                         ▼
               Static Timing Analysis
                         │
                         ▼
                   DRC / LVS
                         │
                         ▼
                       GDSII
```

<details>
<summary><b>🛠️ Planned EDA Toolchain</b></summary>

<br>

| Design Stage | Tool |
|---|---|
| RTL | SystemVerilog |
| Simulation | Verilator / Cadence |
| Waveform Debug | GTKWave / SimVision |
| Verification | SystemVerilog + UVM |
| Synthesis | Cadence Genus |
| Physical Design | Cadence Innovus |
| Static Timing | Cadence Tempus |
| Final Layout | GDSII |

</details>

---

# 📊 ASIC Results

This section will be populated as the design progresses through physical implementation.

| Metric | Result |
|---|---:|
| Technology Node | TBD |
| Target Clock | TBD |
| Achieved Frequency | TBD |
| Standard Cells | TBD |
| Core Area | TBD |
| Utilization | TBD |
| Total Power | TBD |
| WNS | TBD |
| TNS | TBD |
| DRC Violations | TBD |
| LVS | TBD |

---

# 🗺️ Roadmap

```text
                    PROJECT ROADMAP

[✓] RTL Fundamentals
 │
 ├── [✓] PC
 ├── [✓] Instruction Memory
 ├── [✓] Register File
 ├── [✓] Decoder
 ├── [✓] ALU
 └── [🚧] Data Memory
           │
           ▼
[ ] Complete Single-Cycle RV32I
           │
           ▼
[ ] 5-Stage Pipeline
           │
           ├── Forwarding
           ├── Hazard Detection
           └── Pipeline Flush
           │
           ▼
[ ] SystemVerilog Verification
           │
           ▼
[ ] UVM Verification
           │
           ▼
[ ] Logic Synthesis
           │
           ▼
[ ] Physical Design
           │
           ▼
[ ] STA + Signoff
           │
           ▼
[ ] GDSII
```

---

# 📂 Repository Structure

```text
rv32_Asic_uvm/
│
├── rtl/                     # Synthesizable RTL
│   ├── pc.sv
│   ├── imem.sv
│   ├── immgen.sv
│   ├── inst_dec.sv
│   ├── register_file.sv
│   └── alu.sv
│
├── tb/                      # SystemVerilog testbenches
│
├── uvm/                     # UVM verification environment
│
├── programs/                # RISC-V programs / memory files
│
├── constraints/             # ASIC timing constraints
│
├── scripts/                 # Simulation / ASIC scripts
│
├── reports/                 # Timing / area / power reports
│
├── docs/                    # Architecture / waveforms
│
└── README.md
```

---

# 📈 Development Progress

```text
RTL Core            ████████░░░░░░░░  In Progress
RV32I ISA           █████░░░░░░░░░░░  In Progress
Pipeline            ░░░░░░░░░░░░░░░░  Planned
SV Verification     ░░░░░░░░░░░░░░░░  Planned
UVM                 ░░░░░░░░░░░░░░░░  Planned
Synthesis           ░░░░░░░░░░░░░░░░  Planned
Physical Design     ░░░░░░░░░░░░░░░░  Planned
Signoff             ░░░░░░░░░░░░░░░░  Planned
GDSII               ░░░░░░░░░░░░░░░░  Planned
```

---

# 🎯 Final Goal

By the end of the project:

```text
                    RISC-V ISA
                        ↓
                 Microarchitecture
                        ↓
                 SystemVerilog RTL
                        ↓
                   Verification
                        ↓
                       UVM
                        ↓
                  RTL Synthesis
                        ↓
                Physical Design
                        ↓
                  Timing Closure
                        ↓
                  Physical Signoff
                        ↓
                      GDSII
```

The objective is to understand **what happens at every layer between an instruction and the final silicon layout**.

---

<div align="center">

## ⚡ From Instruction Set to Silicon

**Designed from scratch • Verified systematically • Implemented as an ASIC**

<br>

### 🚧 Currently under active development

⭐ **Star the repository to follow the RTL → GDSII journey.**

</div>
