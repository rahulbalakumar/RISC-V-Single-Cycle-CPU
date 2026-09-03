module data_memory(
    input logic clk,
    input logic [31:0] alu_result,
    input logic [31:0] data_out2,
    input logic mem_wr_en,
    output logic [31:0] mem_out
);

    logic [31:0] data_mem [0:1023];

    always_ff @(posedge clk) begin
        if (mem_wr_en) begin
            data_mem[alu_result[11:2]] <= data_out2;
        end
    end

    always_comb begin
        mem_out = data_mem[alu_result[11:2]];
    end

endmodule