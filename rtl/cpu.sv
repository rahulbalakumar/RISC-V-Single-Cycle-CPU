module cpu (
    input logic clk, 
    input logic rstn
);

    logic [31:0] current_pc; // PC
    logic [31:0] instruction; // Instruction Memory
    logic [31:0] data_out1, data_out2; // Register File
    logic [31:0] imm; // Immediate Generator
    logic reg_wr_en, mem_wr_en;
    logic [1:0] operand_sel, pc_control, reg_sel; // Control Unit
    logic [3:0] alu_control; // ALU Control
    logic [31:0] operand_a, operand_b; // Operand MUX
    logic [31:0] result;
    logic zero; // ALU
    logic [31:0] next_pc, pc_plus4; // Branch Unit
    logic [31:0] mem_out; // Data Memory
    logic [31:0] data_in; // Register MUX

    pc pc1 (.next_pc(next_pc),
            .clk(clk),
            .rstn(rstn),
            .current_pc(current_pc));
    
    instruction_memory instr_mem (.current_pc(current_pc),
                                  .instruction(instruction));
    
    reg_file regfile(.clk(clk),
                     .data_in(data_in),
                     .rd(instruction[11:7]),
                     .reg_wr_en(reg_wr_en),
                     .rs1(instruction[19:15]),
                     .rs2(instruction[24:20]),
                     .data_out1(data_out1),
                     .data_out2(data_out2));
    
    immediate_generator immgen(.instruction(instruction),
                               .imm(imm));

    control_unit controlunit(.instruction(instruction),
                             .operand_sel(operand_sel),
                             .pc_control(pc_control),
                             .reg_sel(reg_sel),
                             .reg_wr_en(reg_wr_en),
                             .mem_wr_en(mem_wr_en));
    
    alu_control alucontrol(.instruction(instruction),
                           .alu_control(alu_control));
    
    op_mux opmux(.data_out1(data_out1),
                 .data_out2(data_out2),
                 .current_pc(current_pc),
                 .imm(imm),
                 .operand_sel(operand_sel),
                 .operand_a(operand_a),
                 .operand_b(operand_b));
    
    alu alu1(.alu_control(alu_control),
             .operand_a(operand_a),
             .operand_b(operand_b),
             .result(result),
             .zero(zero));

    branch_unit branchunit(.current_pc(current_pc),
                           .imm(imm),
                           .funct3(instruction[14:12]),
                           .zero(zero),
                           .alu_result(result),
                           .pc_control(pc_control),
                           .next_pc(next_pc),
                           .pc_plus4(pc_plus4));

    data_memory datamemory(.clk(clk),
                           .alu_result(result),
                           .data_out2(data_out2),
                           .mem_wr_en(mem_wr_en),
                           .mem_out(mem_out));
    
    reg_mux regmux(.alu_result(result),
                   .mem_out(mem_out),
                   .pc_plus4(pc_plus4),
                   .reg_sel(reg_sel),
                   .data_in(data_in));

endmodule


