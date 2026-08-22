`timescale 1ns / 1ps

module tb_instruction_memory;

    logic [31:0] current_pc;
    logic [31:0] instruction;

    instruction_memory dut (.current_pc(current_pc),
                            .instruction(instruction));

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
        current_pc = 12'd0;
        #10;
        current_pc = 12'd1;
        #10;
        current_pc = 12'd2;

        $finish();
    end
endmodule