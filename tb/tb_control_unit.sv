`timescale 1ns / 1ps
module tb_control_unit;

    logic [31:0] instr;
    logic reg_wr_en;
    logic mem_wr_en;
    logic [1:0] pc_control;
    logic [1:0] reg_sel;

    control_unit dut (.*);

    initial begin
        instr = 32'b0000_0000_0000_0000_0000_0000_0_0110011; // ADD
        $display("--------ADD-----------");
        #1;
        if (reg_wr_en == 1'b1)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 1, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b00)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 00, got %b", pc_control);
        if (reg_sel == 2'b00)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 00, got %b", reg_sel);
        
        instr = 32'b0000_0000_0000_0000_0000_0000_0_0010011; // ADDI
        $display("--------ADDI-----------");
        #1;
        if (reg_wr_en == 1'b1)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 1, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b00)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 00, got %b", pc_control);
        if (reg_sel == 2'b00)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 00, got %b", reg_sel);
        
        instr = 32'b0000_0000_0000_0000_0000_0000_0_0100011; // SW
        $display("--------SW-----------");
        #1;
        if (reg_wr_en == 1'b0)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 0, got %b", reg_wr_en);
        if (mem_wr_en == 1'b1)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 1, got %b", mem_wr_en);
        if (pc_control == 2'b00)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 00, got %b", pc_control);
        if (reg_sel == 2'b00)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 00, got %b", reg_sel);
        
        instr = 32'b0000_0000_0000_0000_0000_0000_0_1100011; // BEQ
        $display("--------BEQ-----------");
        #1;
        if (reg_wr_en == 1'b0)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 0, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b01)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 01, got %b", pc_control);
        if (reg_sel == 2'b00)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 00, got %b", reg_sel);
        
        
        instr = 32'b0000_0000_0000_0000_0000_0000_0_0000011; // LW
        $display("--------LW-----------");
        #1;
        if (reg_wr_en == 1'b1)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 1, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b00)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 00, got %b", pc_control);
        if (reg_sel == 2'b01)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 01, got %b", reg_sel);
        
        instr = 32'b0000_0000_0000_0000_0000_0000_0_1101111; // JAL
        $display("--------JAL-----------");
        #1;
        if (reg_wr_en == 1'b1)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 1, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b10)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 10, got %b", pc_control);
        if (reg_sel == 2'b10)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 10, got %b", reg_sel);
        
         instr = 32'b0000_0000_0000_0000_0000_0000_0_1100111; // JALR
        $display("--------JALR-----------");
        #1;
        if (reg_wr_en == 1'b1)
            $display("reg_wr_en PASS");
        else
            $display("reg_wr_en FAIL: expected 1, got %b", reg_wr_en);
        if (mem_wr_en == 1'b0)
            $display("mem_wr_en PASS");
        else
            $display("mem_wr_en FAIL: expected 0, got %b", mem_wr_en);
        if (pc_control == 2'b11)
            $display("pc_control PASS");
        else
            $display("pc_control FAIL: expected 11, got %b", pc_control);
        if (reg_sel == 2'b10)
            $display("reg_sel PASS");
        else
            $display("reg_sel FAIL: expected 10, got %b", reg_sel);
        

        $finish();
    end
endmodule