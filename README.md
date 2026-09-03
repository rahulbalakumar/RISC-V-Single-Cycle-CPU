# RISC-V Single-Cycle CPU (SystemVerilog)

A single-cycle RV32I CPU implementation in SystemVerilog, built module-by-module with a directed self-checking testbench for each.

## Status

Supports: R-type, I-type (arithmetic), S-type (SW), B-type (BEQ/BNE), LW, JAL, JALR.

| Module | File | Status |
|---|---|---|
| Program Counter | `pc.sv` | ✅ Verified |
| Instruction Memory | `instruction_memory.sv` | ✅ Verified |
| Register File | `reg_file.sv` | ✅ Verified |
| Immediate Generator | `immediate_generator.sv` | ✅ Verified |
| Control Unit | `control_unit.sv` | ✅ Verified |
| ALU Control | `alu_control.sv` | ✅ Verified (21/21 tests) |
| ALU | `alu.sv` | ✅ Verified |
| Operand Mux | `op_mux.sv` | ✅ Verified |
| Branch Unit (PC control) | `branch_unit.sv` | ✅ Verified (9/9 tests) |
| Data Memory | — | 🔲 Not started |
| Top-level Datapath | — | 🔲 Not started |

## Architecture

Single-cycle datapath, all address/data widths are 32-bit. Instruction memory is 4KB (1024 words), byte-addressed but word-aligned (`current_pc[11:2]` indexes the memory array).

### Control Signals

**`control_unit.sv`** decodes the opcode (`instr[6:0]`) and drives:

- `reg_wr_en` — register file write enable
- `mem_wr_en` — data memory write enable
- `pc_control[1:0]` — selects next-PC source: `00`=sequential, `01`=branch, `10`=JAL, `11`=JALR
- `reg_sel[1:0]` — selects register writeback source: `00`=ALU result, `01`=memory read data, `10`=PC+4 (link address)
- `operand_sel[1:0]` — selects ALU operand pair: `00`=rs1/rs2, `01`=rs1/immediate, `10`=PC/immediate (JAL)

**`alu_control.sv`** decodes the ALU operation directly from the full instruction (opcode → funct3 → funct7), independent of the Control Unit.

### Operand Muxing

`op_mux.sv` uses the single `operand_sel` signal to jointly drive both ALU operands, since the instruction set only requires three distinct (operand_a, operand_b) combinations:

| `operand_sel` | operand_a | operand_b | Instructions |
|---|---|---|---|
| `00` | rs1 | rs2 | R-type, BEQ/BNE |
| `01` | rs1 | immediate | I-type, SW, LW, JALR |
| `10` | current_pc | immediate | JAL |

JAL and JALR both reuse the shared ALU for target address calculation rather than a dedicated adder — JAL computes PC+imm, JALR computes rs1+imm, both via the ALU's ADD operation.

### Branch / Next-PC Logic

`branch_unit.sv` computes the next PC value. It contains two independent adders (PC+4 and PC+immediate) since the shared ALU is simultaneously occupied computing the rs1−rs2 comparison during branch instructions:

- Branch taken/not-taken is resolved from `funct3` (distinguishes BEQ from BNE, since `control_unit.sv` does not) combined with the ALU's `zero` flag: BEQ taken on `zero==1`, BNE taken on `zero==0`.
- JAL and JALR read their target directly from `alu_result` (see Operand Muxing above) rather than computing it locally.
- JALR's target has its least-significant bit forced to `0` per the RISC-V spec, applied only on the JALR path (the other three paths are guaranteed word-aligned by construction and don't need it).

## Verification

Each module has its own self-checking SystemVerilog testbench with directed test cases and a pass/fail tally, covering:
- All opcode/funct3/funct7 decode paths
- Default/unused encodings (latch-avoidance safety nets)
- Edge cases specific to each module (e.g. JALR LSB clearing on both even and odd inputs)

## Next Steps

1. Data Memory module (word-addressed, synchronous write / combinational read)
2. Top-level datapath wiring, connecting all verified modules
3. End-to-end instruction-level testing via `instructions.txt` memory image