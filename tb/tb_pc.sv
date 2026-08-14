`timescale 1ns / 1ps

module tb_pc;

    logic [11:0] next_pc;
    logic clk;
    logic rstn;
    logic [11:0] current_pc;

    pc dut (.next_pc(next_pc),
            .clk(clk),
            .rstn(rstn),
            .current_pc(current_pc));

    initial begin 
        clk = 0;
        $dumpfile("dump.vcd");$dumpvars(0,dut);
    end

    initial begin 
        forever #5 clk = ~clk;
    end

    initial begin 

        #10;
        rstn = 0;
        #10;
        rstn = 1;
        next_pc = 12'd101;
        #10;

        $finish();
    end
endmodule
