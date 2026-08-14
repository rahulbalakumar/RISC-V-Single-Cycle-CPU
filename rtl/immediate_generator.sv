module immediate_generator(
    input logic [31:0] instr,
    output logic [31:0] ext_instr
);

    always_comb begin
        case (instr[6:0])
            7'b0110011 : ext_instr = '0; // R - type
            7'b0010011, 7'b0000011, 7'b1100111 : ext_instr = {{20{instr[31]}},{instr[31:20]}}; // I - type
            7'b0100011 : ext_instr = {{20{instr[31]}},{instr[31:25]},{instr[11:7]}}; // S - type
            7'b1100011 : ext_instr = {{19{instr[31]}},{instr[31]},{instr[7]},{instr[30:25]},{instr[11:8]},{1'b0}}; // B - type
            7'b0110111, 7'b0010111 : ext_instr = {{instr[31:12]},{12'b0}}; // U - type
            7'b1101111 : ext_instr = {{11{instr[31]}},{instr[31]},{instr[19:12]},{instr[20]},{instr[30:21]},{1'b0}}; // J - type
            default : ext_instr = '0;
        endcase
    end

endmodule