module immediate_generator(
    input logic [31:0] instruction,
    output logic [31:0] imm
);

    always_comb begin
        case (instruction[6:0])
            7'b0110011 : imm = '0; // R - type
            7'b0010011, 7'b0000011, 7'b1100111 : imm = {{20{instruction[31]}},{instruction[31:20]}}; // I - type
            7'b0100011 : imm = {{20{instruction[31]}},{instruction[31:25]},{instruction[11:7]}}; // S - type
            7'b1100011 : imm = {{19{instruction[31]}},{instruction[31]},{instruction[7]},{instruction[30:25]},{instruction[11:8]},{1'b0}}; // B - type
            7'b0110111, 7'b0010111 : imm = {{instruction[31:12]},{12'b0}}; // U - type
            7'b1101111 : imm = {{11{instruction[31]}},{instruction[31]},{instruction[19:12]},{instruction[20]},{instruction[30:21]},{1'b0}}; // J - type
            default : imm = '0;
        endcase
    end

endmodule