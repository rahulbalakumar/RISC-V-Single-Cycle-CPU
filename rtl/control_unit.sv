module control_unit (
    input logic [31:0] instr,
    output logic reg_wr_en,
    output logic mem_wr_en,
    output logic [1:0] opreand_sel,
    output logic [1:0] pc_control,
    output logic [1:0] reg_sel
);

    always_comb begin
        case(instr[6:0])
            7'b0110011 : begin 
                reg_wr_en = 1'b1; mem_wr_en = 1'b0; opreand_sel = 2'b00; pc_control = 2'b00; reg_sel = 2'b00; // ADD
            end
            7'b0010011 : begin
                 reg_wr_en = 1'b1; mem_wr_en = 1'b0; opreand_sel = 2'b01; pc_control = 2'b00; reg_sel = 2'b00; // ADDI
            end
            7'b0100011 : begin reg_wr_en = 1'b0; mem_wr_en = 1'b1; opreand_sel = 2'b01; pc_control = 2'b00; reg_sel = 2'b00; // SW
            end
            7'b1100011 : begin reg_wr_en = 1'b0; mem_wr_en = 1'b0; opreand_sel = 2'b00; pc_control = 2'b01; reg_sel = 2'b00; // BEQ
            end
            7'b0000011 : begin reg_wr_en = 1'b1; mem_wr_en = 1'b0; opreand_sel = 2'b01; pc_control = 2'b00; reg_sel = 2'b01; // LW
            end
            7'b1101111 : begin reg_wr_en = 1'b1; mem_wr_en = 1'b0; opreand_sel = 2'b10; pc_control = 2'b10; reg_sel = 2'b10; // JAL
            end
            7'b1100111 : begin reg_wr_en = 1'b1; mem_wr_en = 1'b0; opreand_sel = 2'b01; pc_control = 2'b11; reg_sel = 2'b10; // JALR
            end
            default : begin reg_wr_en = 1'b0; mem_wr_en = 1'b0; opreand_sel = 2'b00; pc_control = 2'b00; reg_sel = 2'b00;
            end
        endcase
    end
endmodule 