# RISC-V Single-Cycle CPU (SystemVerilog)

A complete single-cycle RV32I CPU implementation in SystemVerilog, built module-by-module with a directed self-checking testbench for each, then verified end-to-end via a full-program integration test.

## Status: Core datapath complete and verified ✅

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
| Data Memory | `data_memory.sv` | ✅ Verified (5/5 tests) |
| Register Writeback Mux | `reg_mux.sv` | ✅ Wired and integration-tested |
| Top-level Datapath | `cpu.sv` | ✅ Fully wired, integration-tested |

## Architecture

Single-cycle datapath, all address/data widths are 32-bit. Instruction and data memory are each 4KB (1024 words), byte-addressed but word-aligned (`current_pc[11:2]` / `alu_result[11:2]` indexes the memory arrays).

### Control Signals

**`control_unit.sv`** decodes the opcode (`instruction[6:0]`) and drives:

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

### Register Writeback

`reg_mux.sv` selects what gets written back into `reg_file.sv`'s `data_in` port, using `reg_sel` from the Control Unit: `00`=ALU result, `01`=data memory read output, `10`=PC+4 (the link address, used by both JAL and JALR).

### Top-Level Wiring (`cpu.sv`)

All 11 modules are instantiated in fetch → decode → execute → memory → writeback order, using named port connections throughout. `reg_file`'s `rd`/`rs1`/`rs2` are sliced directly from `instruction` at the instantiation site rather than as separate top-level wires. The top module exposes only `clk` and `rstn` — it is a closed loop with no other external I/O, since instruction memory is preloaded via `$readmemh` and there are currently no debug/observation ports.

## Verification

Each module has its own self-checking SystemVerilog testbench with directed test cases and a pass/fail tally, covering:
- All opcode/funct3/funct7 decode paths
- Default/unused encodings (latch-avoidance safety nets)
- Edge cases specific to each module (e.g. JALR LSB clearing on both even and odd inputs, memory write-enable gating)

### Integration Test

A 12-instruction hand-assembled program (`instructions.txt`) exercises every supported instruction type in one run: ADDI, ADD, SW, LW, a taken BEQ, and a JAL — each with a deliberate "skip" instruction immediately after the branch/jump that must NOT execute if control flow is correct, plus a final `JAL x0, 0` self-loop to safely halt the single-cycle CPU. Verified via `tb_cpu.sv` using hierarchical references into the DUT (`dut.regfile.regs[N]`, `dut.datamemory.data_mem[N]`) since `cpu.sv` has no output ports.

**Program listing:**

| Addr | Instruction | Hex | Purpose |
|---|---|---|---|
| 0x00 | `ADDI x1, x0, 5` | `00500093` | x1 = 5 |
| 0x04 | `ADDI x2, x0, 10` | `00A00113` | x2 = 10 |
| 0x08 | `ADD x3, x1, x2` | `002081B3` | x3 = 15 (R-type) |
| 0x0C | `SW x3, 0(x0)` | `00302023` | mem[0] = 15 (S-type) |
| 0x10 | `LW x4, 0(x0)` | `00002203` | x4 = 15 (load) |
| 0x14 | `BEQ x1, x1, 8` | `00108463` | always taken, skips 0x18 |
| 0x18 | `ADDI x5, x0, 99` | `06300293` | **skipped** — should never execute |
| 0x1C | `ADDI x5, x0, 7` | `00700293` | x5 = 7 (branch target) |
| 0x20 | `JAL x6, 8` | `0080036F` | x6 = 0x24 (link addr), jumps to 0x28 |
| 0x24 | `ADDI x7, x0, 55` | `03700393` | **skipped** — should never execute |
| 0x28 | `ADDI x7, x0, 42` | `02A00393` | x7 = 42 (JAL target) |
| 0x2C | `JAL x0, 0` | `0000006F` | infinite self-loop (halts execution) |

**Result — all 8 checks passed:**

| Register/Memory | Expected | Actual |
|---|---|---|
| x1 | 5 | 5 |
| x2 | 10 | 10 |
| x3 | 15 | 15 |
| x4 | 15 | 15 |
| x5 | 7 | 7 |
| x6 | 0x24 | 0x24 |
| x7 | 42 | 42 |
| mem[0] | 15 | 15 |

Both skip cases resolving correctly (x5=7 not 99, x7=42 not 55) confirms branch and jump control flow work, not just the ALU/memory data paths — a bug in `branch_unit`'s taken-logic or `op_mux`'s JAL operand selection would have shown up as a wrong value in x5 or x7. x6=0x24 confirms the JAL link-address path through `reg_mux` (`reg_sel==10`) into the register file. mem[0]/x4 confirm the SW→LW round trip through `data_memory`.

## Possible Next Steps

- Extend branch support beyond BEQ/BNE if needed, or add remaining RV32I instructions (LUI, AUIPC, remaining branch types, byte/halfword loads and stores)
- Add debug/observation ports to `cpu.sv` for easier external testing without hierarchical references
- Expand the integration test program for broader coverage (e.g. negative immediates, JALR, back-to-back branches)