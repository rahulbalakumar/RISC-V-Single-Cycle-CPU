module reg_mux (
    input logic [31:0] alu_result,
    input logic [31:0] mem_out,
    input logic [31:0] pc_plus4,
    input logic [1:0] reg_sel,
    output logic [31:0] data_in
);

    always_comb begin
        case(reg_sel)
            2'b00: data_in = alu_result;
            2'b01: data_in = mem_out;
            2'b10: data_in = pc_plus4;
            default: data_in = alu_result;
        endcase
    end
endmodule