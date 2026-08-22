module alu (
    input logic [3:0] alu_control,
    input logic [31:0] operand_a,
    input logic [31:0] operand_b,
    output logic [31:0] result,
    output logic zero
);

    always_comb begin
        case(alu_control)
            4'b0000: begin // ADD
                result = operand_a + operand_b;
            end
            4'b0001: begin // SUB
                result = operand_a - operand_b;
            end
            4'b0010: begin // SLL
                result = operand_a << operand_b[4:0];
            end
            4'b0011: begin // SLT
                result = {31'b0,($signed(operand_a) < $signed(operand_b))};
            end
            4'b0100: begin // SLTU
                result = {31'b0,(operand_a < operand_b)};
            end
            4'b0101: begin // XOR
                result = operand_a ^ operand_b;
            end
            4'b0110: begin // SRL
                result = operand_a >> operand_b[4:0];
            end
            4'b0111: begin // SRA
                result = $signed(operand_a) >>> operand_b[4:0];
            end
            4'b1000: begin // OR
                result = operand_a | operand_b;
            end
            4'b1001: begin // AND
                result = operand_a & operand_b;
            end
            default: begin
                result = operand_a + operand_b;
            end
        endcase

        zero = (result == 0);
    end
endmodule