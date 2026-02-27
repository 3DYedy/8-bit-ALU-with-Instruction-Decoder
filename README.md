# 8-bit-ALU-with-Instruction-Decoder

## 1. Project Overview
This project implements an **Arithmetic Logic Unit (ALU)** in SystemVerilog. Unlike basic ALUs, this design is driven by a custom **16-bit Instruction Set Architecture (ISA)** that handles hierarchical data routing and operation selection.

## 2. Design Architecture (Reference Schematic)
The design follows the architectural below, featuring a multi-stage multiplexer hierarchy and a 4-way output demultiplexer.

<img width="990" height="675" alt="image" src="https://github.com/user-attachments/assets/5b37b800-24b0-4c44-b06a-e55779dfab6a" />

### Instruction Bit-Mapping:
* **Bits [15:14]**: Output Location Selection (Demux 4-way).
* **Bits [13:12]**: Operation Category (Arithmetic, Logic, Special, Zero).
* **Bits [11:10]**: Specific Operation Selection (Add/Sub/Shift/AND/OR/XOR).

---

## 3. Features & Modules
* **Arithmetic Unit:** Supports Addition, Subtraction, and Logical Shifting (Left/Right).
* **Logic Unit:** Performs bitwise AND, OR, XOR operations and generates constants.
* **Special Module:** A custom bit-matching unit that detects if MSB and LSB of both inputs are identical.
* **Status Flags:** Real-time generation of **Overflow Flag** (for sums > 255) and **Zero Flag** (for null results).

---

## 4. Verification

### Waveform Analysis
<img width="1117" height="314" alt="image" src="https://github.com/user-attachments/assets/ff8e846c-9ac4-4139-a5d4-24f18cbfc2dd" />

**Key Verification Milestones:**
1. **Output Routing:** Demonstrated seamless switching between `out0`, `out1`, `out2`, and `out3` based on instructions.
2. **Overflow Detection:** Verified at **20ns** when adding 200 + 150 (Result: 94 with `overflow_flag` HIGH).
3. **Zero Detection:** Verified at **30ns** (Bitwise AND of AA and 55) and **50ns** (Subtraction of 42 - 42).
4. **Shift Logic:** Confirmed 7 << 2 resulting in 28 (`1c` Hex) at **40ns**.
