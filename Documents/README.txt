# FPGA RISC Processor & MIPS Tooling

This project implements a RISC-based processor architecture (MIPS instruction set) on an FPGA, accompanied by a Python tool for code processing and assembly helper functions.

## What It Does
1. **FPGA Core (`FPGA_RISC/`):** Executes custom MIPS instructions. It handles the core components of a CPU including the ALU, Control Unit, Registers, and Memory interfaces.
2. **Python Helper (`mips_tool.py`):** Automates the processing, parsing, or binary generation of MIPS assembly code so it can be loaded into the FPGA hardware.
3. **Documentation:** Full hardware specifications and engineering choices are detailed in the included PDF report.

---

## Repository Structure
* `FPGA_RISC/` - Hardware description source files (Verilog/VHDL).
* `mips_tool.py` - Python script for processing MIPS assembly/machine code.
* `TranThiNgocHuyen_ITITIU23009_FinalReport.pdf` - Project documentation.

---

## How to Setup and Run

### 1. Hardware Simulation & Synthesis
To run or test the hardware processor core:
1. Open your FPGA IDE (e.g., Vivado, Quartus, or ModelSim).
2. Import the source files located inside the `FPGA_RISC/` directory.
3. Compile and run your testbenches to simulate the instruction execution.

### 2. Running the Python Tool
Use the script to prepare or process your MIPS code before sending it to the processor. 
1. Open your terminal or command prompt.
2. Navigate to this project directory.
3. Run the script using Python 3:
```bash
python mips_tool.py