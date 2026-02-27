# 8-bit ALU with Instruction Decoder (SystemVerilog)

## 1. Overview
This project implements a simplified **8-bit Arithmetic Logic Unit (ALU)** with an integrated instruction decoder, inspired by the internal structure of a basic processor datapath. 

The ALU performs arithmetic and logical operations on two 8-bit input operands and outputs the result to one of four selectable destinations (e.g., register blocks). In addition to the main result, the design generates status flags that signal special conditions such as overflow or zero results.

---

## 2. Architecture
The system is structured around a modular RTL approach, separating the control logic from the datapath:

* **Instruction Decoder:** Decodes the 16-bit instruction word to drive internal select signals.
* **Arithmetic & Logic Modules:** Independent blocks for ADD, SUB, AND, OR, XOR, and Shifting.
* **Special Logic Module:** Detects specific bit patterns across operands.
* **Output Routing:** A 4-way demultiplexer routes the 8-bit result to `out0`, `out1`, `out2`, or `out3`.
* **Status Flag Logic:** Real-time monitoring for Overflow and Zero conditions.

### Reference Schematic
<img width="978" height="691" alt="image" src="https://github.com/user-attachments/assets/47a10831-aa49-4612-8df0-1366e9217384" />

---

## 3. Instruction Format (16-bit ISA)
The operation to be executed is determined by specific bits within a 16-bit instruction word, mimicking a simplified Instruction Set Architecture (ISA):

| Bit Range | Function | Description |
| :--- | :--- | :--- |
| **[15:14]** | **Output Location** | Selects destination: `out0`, `out1`, `out2`, or `out3` |
| **[13:12]** | **Operation Category**| Selects between Arithmetic, Logic, Special, or Zero categories |
| **[11:10]** | **Opcode Selection** | Selects the specific operation within the chosen category |

---

## 4. Supported Operations

### Arithmetic & Shift Units
* **ADD / SUB:** Standard 8-bit arithmetic.
* **Overflow Flag:** Set to `1` when the sum exceeds the 8-bit range ($Result > 255$).
* **Shifters:** Logical shift left and logical shift right on `in0` using `in1` as the shift amount.

### Logic & Comparator Units
* **Bitwise Ops:** AND, OR, and XOR.
* **Equality Check:** The `comp_eq` module outputs `1` if $in_0 = in_1$.

### Special Module
The "special" module outputs `1` if the Most Significant Bit (MSB) and Least Significant Bit (LSB) of both inputs are all equal:
$$MSB(in_0) = LSB(in_0) = MSB(in_1) = LSB(in_1) \implies Result = 1$$

---

## 5. Verification & Simulation Results
The design was fully validated using **Xilinx Vivado** with a comprehensive stress-test testbench. 

### Waveform Analysis
<img width="1295" height="310" alt="image" src="https://github.com/user-attachments/assets/e4aa78fa-f729-43a0-bbb3-d0f13696a8c6" />

**Key Verification Milestones:**
* **Overflow Verification:** Confirmed at **20ns** during a 200 + 150 addition (Result: 94 with `overflow_flag` High).
* **Zero Flag Verification:** Confirmed at **30ns** (Bitwise AND of AA and 55) and **50ns** (Subtraction of 42 - 42).
* **Routing Accuracy:** Successfully validated data routing across all four output ports (`out0`-`out3`) based on instruction bits.

---
**Design Characteristics:**
* 8-bit Datapath.
* 16-bit Instruction Word.
* Fully Synchronous Behavioral Logic.
* Validated via Waveform Analysis in Vivado.
