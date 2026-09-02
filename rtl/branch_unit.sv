module branch_unit (
    input logic [31:0] current_pc,
    input logic [31:0] imm,
    input logic [2:0] funct3,
    input logic zero,
    input logic [31:0] alu_result,
    input logic [1:0] pc_control,
    output logic [31:0] next_pc,
    output logic [31:0] pc_plus4
);
    logic [31:0] branch_target;
    logic branch_taken;

    always_comb begin
        if (funct3 == 3'b000 && zero == 1) begin
            branch_taken = 1'b1;
        end else if (funct3 == 3'b001 && zero == 0) begin
            branch_taken = 1'b1;
        end else begin
            branch_taken = 1'b0;
        end
    end

    always_comb begin
        pc_plus4 = current_pc + 32'd4;
        branch_target = current_pc + imm;
        

        case (pc_control)
            2'b00: next_pc = pc_plus4;
            2'b01: next_pc = branch_taken ? branch_target : pc_plus4;
            2'b10: next_pc = alu_result; // JAL
            2'b11: next_pc = {alu_result[31:1], 1'b0}; // JALR , LSB forced to 0
            default: next_pc = pc_plus4;
        endcase
    end
endmodule 
