`timescale 1ns / 1ps

module tb_reg_file;

    logic clk;
    logic [31:0] data_in;
    logic [4:0] rd;
    logic wr;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [31:0] data_out1;
    logic [31:0] data_out2;

    reg_file dut (.clk(clk),
                  .data_in(data_in),
                  .rd(rd),
                  .wr(wr),
                  .rs1(rs1),
                  .rs2(rs2),
                  .data_out1(data_out1),
                  .data_out2(data_out2));

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
        clk = 0;
        wr = 0;
    end

    initial begin 
        forever #5 clk = ~clk;
    end

    initial begin
        #10;
        wr = 1;
        rd = 5'd1;
        data_in = 32'd155;
        #10;

        rs1 = 0;
        rs2 = 1;
        #10;
        $finish();
    end
endmodule