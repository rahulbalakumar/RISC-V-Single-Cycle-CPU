`timescale 1ns / 1ps
module tb_alu;
    logic [3:0] alu_control;
    logic [31:0] operand_a, operand_b;
    logic [31:0] result;
    logic zero;

    alu dut (.*);

    initial begin
        $dumpfile("dump.vcd");$dumpvars(0,dut);
        // This testcase to test the edge case of subtracting INT_MAX (0xh7FFFFFFF) from INT_MIN (0x80000000)
        alu_control = 4'b0011; // SLT
        operand_a = 32'h7FFF_FFFF;
        operand_b = 32'h8000_0000;
        #1;
        $display("----------SLT----------------");
        assert (result == 32'h0)
        else $display("FAIL: SLT, got result = %h expected %h", result, 32'h0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);
        // RV32I defines only first 5 bits in operand B to be the shift amount 
        alu_control = 4'b0010; // SLL
        operand_a = 32'd32;
        operand_b = 32'hFFFF_FFE1;
        #1;
        $display("----------SLL----------------");
        assert (result == 32'd64)
        else $display("FAIL: SLL, got result = %h, expected %h", result, 32'd64);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);
        // SRA & SRL sign extension case
        alu_control = 4'b0111; // SRA
        operand_a = 32'h8000_0000;
        operand_b = 32'd4;
        #1;
        $display("----------SRA----------------");
        assert (result == 32'hF800_0000)
        else $display("FAIL: SRA, got result = %h, expected %h", result, 32'hF800_0000);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);
        alu_control = 4'b0110; // SRL
        operand_a = 32'h8000_0000;
        operand_b = 32'd4;
        #1;
        $display("----------SRL----------------");
        assert (result == 32'h0800_0000)
        else $display("FAIL: SRL, got result = %h, expected %h", result, 32'h0800_0000);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);
        

        // ADD
        alu_control = 4'b0000;
        operand_a = 32'd1040;
        operand_b = 32'd4352;
        #1;
        $display("-----------ADD---------------");
        assert (result == 32'd5392)
        else $display("FAIL: ADD, got result = %d, expected %d", result, 32'd5392);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        // SUB
        alu_control = 4'b0001;
        operand_a = 32'd2992;
        operand_b = 32'd1992;
        #1;
        $display("-----------SUB------------");
        assert (result == 32'd1000)
        else $display("FAIL: SUB, got result = %d, expected %d", result, 32'd1000);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        // OR
        alu_control = 4'b1000;
        operand_a = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
        operand_b = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
        #1;
        $display("--------OR--------------");
        assert (result == 32'b1111_1111_1111_1111_1111_1111_1111_1111)
        else $display("FAIL: OR, got result = %b, expected %b",result, 32'b1111_1111_1111_1111_1111_1111_1111_1111);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        // AND
        alu_control = 4'b1001;
        operand_a = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
        operand_b = 32'b0101_0101_0101_0101_0101_0101_0101_0101;
        #1;
        $display("--------AND--------------");
        assert (result == 32'b0)
        else $display("FAIL: AND, got result = %b, expected %b",result, 32'b0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);

        // SLTU
        alu_control = 4'b0100;
        operand_a = 32'd1550;
        operand_b = 32'd2050;
        #1;
        $display("--------SLTU--------------");
        assert (result == 32'd1)
        else $display("FAIL: SLTU, got result = %d, expected %d",result, 32'd1);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);
        
        // XOR
        alu_control = 4'b0101;
        operand_a = 32'b1111_0000_1111_0000_1111_0000_1111_0000;
        operand_b = 32'b0000_1111_0000_1111_0000_1111_0000_1111;
        #1;
        $display("--------XOR--------------");
        assert (result == 32'b1111_1111_1111_1111_1111_1111_1111_1111)
        else $display("FAIL: XOR, got result = %b, expected %b",result, 32'b1111_1111_1111_1111_1111_1111_1111_1111);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        // Edge Cases for AND, OR, XOR
        $display("----------EDGE CASES BITWISE---------------");
        alu_control = 4'b1001; // AND
        operand_a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        operand_b = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        #1;
        $display("--------AND--------------");
        assert (result == 32'b1111_1111_1111_1111_1111_1111_1111_1111)
        else $display("FAIL: AND, got result = %b, expected %b",result, 32'b1111_1111_1111_1111_1111_1111_1111_1111);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        alu_control = 4'b1001; // AND
        operand_a = 32'b0;
        operand_b = 32'b0;
        #1;
        $display("--------AND--------------");
        assert (result == 32'b0)
        else $display("FAIL: AND, got result = %b, expected %b",result, 32'b0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);

        alu_control = 4'b1000; // OR
        operand_a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        operand_b = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        #1;
        $display("--------OR--------------");
        assert (result == 32'b1111_1111_1111_1111_1111_1111_1111_1111)
        else $display("FAIL: OR, got result = %b, expected %b",result, 32'b1111_1111_1111_1111_1111_1111_1111_1111);
        assert (zero == 1'b0)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b0);

        alu_control = 4'b1000; // OR
        operand_a = 32'b0;
        operand_b = 32'b0;
        #1;
        $display("--------OR--------------");
        assert (result == 32'b0)
        else $display("FAIL: OR, got result = %b, expected %b",result, 32'b0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);

        alu_control = 4'b0101; // XOR
        operand_a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        operand_b = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        #1;
        $display("--------XOR--------------");
        assert (result == 32'b0)
        else $display("FAIL: XOR, got result = %b, expected %b",result, 32'b0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);

        alu_control = 4'b0101; // XOR
        operand_a = 32'b0;
        operand_b = 32'b0;
        #1;
        $display("--------XOR--------------");
        assert (result == 32'b0)
        else $display("FAIL: XOR, got result = %b, expected %b",result, 32'b0);
        assert (zero == 1'b1)
        else $display("FAIL: zero, got result = %b, expected %b", zero, 1'b1);

        $finish();
    end

endmodule