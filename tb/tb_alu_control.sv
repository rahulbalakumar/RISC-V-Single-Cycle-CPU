`timescale 1ns / 1ps
module tb_alu_control;
    logic [31:0] instr;
    logic [3:0] alu_control;

    alu_control dut (.*);

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
        // R-Type
        instr = 32'b0000000_10101_11111_000_11000_0110011; // ADD
        $display("-------ADD---------");
        #1;
        if (alu_control == 4'b0000)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0000, got %b", alu_control);
        instr = 32'b0100000_11111_11111_000_11111_0110011; // SUB
        $display("-------SUB---------");
        #1;
        if (alu_control == 4'b0001)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0001, got %b", alu_control);
        instr = 32'b0000000_10101_11111_001_11000_0110011; // SLL
        $display("-------SLL---------");
        #1;
        if (alu_control == 4'b0010)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0010, got %b", alu_control);
        instr = 32'b0000000_10101_11111_010_11000_0110011; // SLT
        $display("-------SLT---------");
        #1;
        if (alu_control == 4'b0011)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0011, got %b", alu_control);
        instr = 32'b0000000_10101_11111_011_11000_0110011; // SLTU
        $display("-------ADD---------");
        #1;
        if (alu_control == 4'b0100)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0100, got %b", alu_control);
        instr = 32'b0000000_10101_11111_100_11000_0110011; // XOR
        $display("-------XOR---------");
        #1;
        if (alu_control == 4'b0101)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0101, got %b", alu_control);
        instr = 32'b0000000_10101_11111_101_11000_0110011; // SRL
        $display("-------SRL---------");
        #1;
        if (alu_control == 4'b0110)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0110, got %b", alu_control);
        instr = 32'b0100000_10101_11111_101_11000_0110011; // SRA
        $display("-------SRA---------");
        #1;
        if (alu_control == 4'b0111)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0111, got %b", alu_control);
        instr = 32'b0000000_10101_11111_110_11000_0110011; // OR
        $display("-------OR---------");
        #1;
        if (alu_control == 4'b1000)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 1000, got %b", alu_control);
        instr = 32'b0000000_10101_11111_111_11000_0110011; // AND
        $display("-------AND---------");
        #1;
        if (alu_control == 4'b1001)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 1001, got %b", alu_control);

        // I-type
        instr = 32'b0000000_10101_11111_000_11000_0010011; // ADDI
        $display("-------ADDI---------");
        #1;
        if (alu_control == 4'b0000)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0000, got %b", alu_control);
        instr = 32'b0000000_10101_11111_010_11000_0010011; // SLTI
        $display("-------SLTI---------");
        #1;
        if (alu_control == 4'b0011)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0011, got %b", alu_control);
        instr = 32'b0000000_10101_11111_011_11000_0010011; // SLTIU
        $display("-------SLTIU---------");
        #1;
        if (alu_control == 4'b0100)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0100, got %b", alu_control);
        instr = 32'b0000000_10101_11111_100_11000_0010011; // XORI
        $display("-------XORI---------");
        #1;
        if (alu_control == 4'b0101)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0101, got %b", alu_control);
        instr = 32'b0000000_10101_11111_001_11000_0010011; // SLLI
        $display("-------SLLI---------");
        #1;
        if (alu_control == 4'b0010)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0010, got %b", alu_control);
        instr = 32'b0000000_10101_11111_101_11000_0010011; // SRLI
        $display("-------SRLI---------");
        #1;
        if (alu_control == 4'b0110)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0110, got %b", alu_control);
        instr = 32'b0100000_10101_11111_101_11000_0010011; // SRAI
        $display("-------SRAI---------");
        #1;
        if (alu_control == 4'b0111)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0111, got %b", alu_control);
        instr = 32'b0000000_10101_11111_110_11000_0010011; // ORI
        $display("-------ORI---------");
        #1;
        if (alu_control == 4'b1000)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 1000, got %b", alu_control);
        instr = 32'b0000000_10101_11111_111_11000_0010011; // ANDI
        $display("-------ANDI---------");
        #1;
        if (alu_control == 4'b1001)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 1001, got %b", alu_control);

        instr = 32'b0000000_10101_11111_000_11000_0100011; // S-type SW
        $display("-------SW---------");
        #1;
        if (alu_control == 4'b0000)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0000, got %b", alu_control);
        instr = 32'b0000000_10101_11111_000_11000_1100011; // B-Type BEQ, BNEQ
        $display("-------BEQ / BNEQ---------");
        #1;
        if (alu_control == 4'b0001)
            $display("alu_control PASS");
        else
            $display("alu_control FAIL: expected 0001, got %b", alu_control);


        
        $finish();
    end

endmodule