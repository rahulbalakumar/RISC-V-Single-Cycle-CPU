module op_mux (
    input logic [31:0] data_out1, data_out2,
    input logic [31:0] current_pc,
    input logic [31:0] imm,
    input logic [1:0] operand_sel,
    output logic [31:0] operand_a, operand_b
);

    always_comb begin
        if (operand_sel == 2'b10) begin
            operand_a = current_pc;
            operand_b = imm;
        end else if (operand_sel == 2'b00) begin
            operand_a = data_out1;
            operand_b = data_out2;
        end else if (operand_sel == 2'b01) begin
            operand_a = data_out1;
            operand_b = imm;
        end else begin
            operand_a = data_out1;
            operand_b = data_out2;
        end
    end

endmodule