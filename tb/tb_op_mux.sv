`timescale 1ns / 1ps
module tb_op_mux;

    logic [31:0] data_out1, data_out2;
    logic [31:0] current_pc;
    logic [31:0] imm;
    logic [1:0] operand_sel;
    logic [31:0] operand_a, operand_b;

    op_mux dut (.*);

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
        operand_sel = 2'b00; // op_a, op_b
        data_out1 = 32'd255;
        data_out2 = 32'd655;
        current_pc = 32'b0000_0000_0000_0000_0000_1000_1001_0100;
        imm = 32'd10000;
        #1;
        operand_sel = 2'b01; // op_a, imm
        data_out1 = 32'd255;
        data_out2 = 32'd655;
        current_pc = 32'b0000_0000_0000_0000_0000_1000_1001_0100;
        imm = 32'd10000;
        #1;
        operand_sel = 2'b11; // op_a, op_b
        data_out1 = 32'd255;
        data_out2 = 32'd655;
        current_pc = 32'b0000_0000_0000_0000_0000_1000_1001_0100;
        imm = 32'd10000;
        #1;
        operand_sel = 2'b10; // pc, imm
        data_out1 = 32'd255;
        data_out2 = 32'd655;
        current_pc = 32'b0000_0000_0000_0000_0000_1000_1001_0100;
        imm = 32'd10000;
        #1;
        $finish();
    end

endmodule