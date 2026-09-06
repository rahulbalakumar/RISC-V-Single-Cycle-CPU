module tb_cpu;
    logic clk;
    logic rstn;

    cpu dut (.*);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);

        rstn = 0;
        @(posedge clk);
        @(posedge clk);
        rstn = 1;
        

        repeat (30) @(posedge clk);

        $display("x1 = %0d (expect 5)", dut.regfile.regs[1]);
        $display("x2 = %0d (expect 10)", dut.regfile.regs[2]);
        $display("x3 = %0d (expect 15)", dut.regfile.regs[3]);
        $display("x4 = %0d (expect 15)", dut.regfile.regs[4]);
        $display("x5 = %0d (expect 7)", dut.regfile.regs[5]);
        $display("x6 = %0h (expect 24)", dut.regfile.regs[6]);
        $display("x7 = %0d (expect 42)", dut.regfile.regs[7]);
        $display("mem[0] = %0d (expect 15)", dut.datamemory.data_mem[0]);
        $finish();

    end

endmodule