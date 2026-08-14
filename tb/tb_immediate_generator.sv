`timescale 1ns / 1ps
module tb_immediate_generator;

    logic [31:0] instr;
    logic [31:0] ext_instr;

    immediate_generator dut (.instr(instr),
                             .ext_instr(ext_instr));


    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
		
      	#10;
        instr = 32'b00100110010011001001100100010011;
      	#10;

        $finish();
    end
endmodule