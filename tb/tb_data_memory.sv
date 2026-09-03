    `timescale 1ns / 1ps
    module tb_data_memory;
        logic clk;
        logic [31:0] alu_result;
        logic [31:0] data_out2;
        logic mem_wr_en;
        logic [31:0] mem_out;

        data_memory dut (.*);
        int pass_count = 0;
        int fail_count = 0;

        initial begin // Clock Driver
            clk = 1'b0;
            forever #5 clk = ~clk;
        end

        initial begin
            // Case 1, Write then read back
            @(posedge clk);
            mem_wr_en = 1'b1;
            alu_result = 32'h004;
            data_out2 = 32'hAAAA_0001;
            @(posedge clk);
            mem_wr_en = 0;
            @(posedge clk);
            if (mem_out == 32'hAAAA_0001) begin
                pass_count++;
                $display("mem_out is %0h",mem_out);
            end else begin
                fail_count++;
                $display("mem_out is wrong, should be 0xAAAA_0001, but got %0h",mem_out);
            end
            // Case 2, Write to different Address
            mem_wr_en = 1'b1;
            alu_result = 32'h008;
            data_out2 = 32'hBBBB_0002;
            @(posedge clk);
            alu_result = 32'h004;
            mem_wr_en = 0;
            @(posedge clk);
            if (mem_out == 32'hAAAA_0001) begin
                pass_count++;
                $display("mem_out is %0h", mem_out);
            end else begin
                fail_count++;
                $display("mem_out is wrong, should be 0xAAAA_0001, but got %0h", mem_out);
            end
            // Case 3, Overwrite old address, Read old address
            mem_wr_en = 1'b1;
            alu_result = 32'h004;
            data_out2 = 32'hCCCC_0003;
            @(posedge clk);
            mem_wr_en = 0;
            @(posedge clk);
            if (mem_out == 32'hCCCC_0003) begin
                pass_count++;
                $display("mem_out is %0h", mem_out);
            end else begin 
                fail_count++;
                $display("mem_out is wrong, should be 0xCCCC_0003, but got %0h", mem_out);
            end
            // Case 4, Check no write when mem_wr_en = 0
            alu_result = 32'h00C;
            data_out2 = 32'hDDDD_0004;
            @(posedge clk);
            if (mem_out !== 32'hDDDD_0004) begin
                pass_count++;
                $display("mem_out is not 0xDDDD_0004");
            end else begin
                fail_count++;
                $display("mem_out is wrong, it shouldn't be 0xDDDD_0004");
            end
            // Case 5, Resetting mem_wr_en = 1 and checking functionality
            mem_wr_en = 1;
            alu_result = 32'h00C;
            data_out2 = 32'hEEEE_0005;
            @(posedge clk);
            mem_wr_en = 0;
            @(posedge clk);
            if (mem_out == 32'hEEEE_0005) begin
                pass_count++;
                $display("mem_out is %0h", mem_out);
            end else begin
                fail_count++;
                $display("mem_out is wrong, shoudl be 0xEEEE_0005, but got %0h", mem_out);
            end

            $display("Passes : %0d, Fails : %0d", pass_count, fail_count);
            $finish();
        end

    endmodule