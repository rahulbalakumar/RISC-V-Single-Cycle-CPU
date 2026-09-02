`timescale 1ns / 1ps
module tb_branch_unit;

    logic [31:0] current_pc,imm;
    logic [2:0] funct3;
    logic zero;
    logic [31:0] alu_result;
    logic [1:0] pc_control;
    logic [31:0] next_pc;
    logic [31:0] pc_plus4;

    branch_unit dut(.*);

    int pass_count = 0;
    int fail_count = 0;

    initial begin
        // Case 1 : pc_control = 00 (normal, PC+4)
        current_pc = 32'd100;
        imm = 32'd0;
        funct3 = 3'b000;
        zero = 1'b0;
        alu_result = 32'd0;
        pc_control = 2'b00;
        #1;
        if (next_pc == 32'd104) begin
            pass_count++;
            $display("Case 1 : PASS - next_pc = %0d",next_pc);
        end else begin
            fail_count++;
            $display("Case 1 : FAIL - expected 104, got %0d", next_pc);
        end

        // Case 2 (branch) : pc_control = 01 (BEQ taken)
        current_pc = 32'd100;
        imm = 32'd100;
        funct3 = 3'b000;
        zero = 1'b1;
        alu_result = 32'd0;
        pc_control = 2'b01;
        #1;
        if (next_pc == 32'd200) begin
            pass_count++;
            $display("Case 2 : PASS - next_pc = %0d",next_pc);
        end else begin
            fail_count++;
            $display("Case 2 : FAIL - expected 200, got %0d", next_pc);
        end

        // Case 3 (branch) : pc_control = 01 (BEQ not taken)
        current_pc = 32'd100;
        imm = 32'd100;
        funct3 = 3'b000;
        zero = 1'b0;
        alu_result = 32'd0;
        pc_control = 2'b01;
        #1;
        if (next_pc == 32'd104) begin
            pass_count++;
            $display("Case 3 : PASS - next_pc = %0d",next_pc);
        end else begin
            fail_count++;
            $display("Case 3 : FAIL - expected 104, got %0d", next_pc);
        end

        // Case 4 (branch) : pc_control = 01 (BNE taken)
        current_pc = 32'd100;
        imm = 32'd100;
        funct3 = 3'b001;
        zero = 1'b0;
        alu_result = 32'd0;
        pc_control = 2'b01;
        #1;
        if (next_pc == 32'd200) begin
            pass_count++;
            $display("Case 4 : PASS - next_pc = %0d",next_pc);
        end else begin
            fail_count++;
            $display("Case 4 : FAIL - expected 200, got %0d", next_pc);
        end
    