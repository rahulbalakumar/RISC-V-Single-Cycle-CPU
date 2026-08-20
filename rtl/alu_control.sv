module alu_control(
    input logic [31:0] inst,
    output logic [3:0] alu_control
);

    always_comb begin
        case(instr[6:0])
            7'b0110011 : begin // R-type
                case(instr[14:12])
                    3'b000: begin // 
                        case(instr[31:25]) 
                            7'b000_000_0: begin // ADD

                            end
                            7'b010_000_0: begin // SUB

                            end 
                        endcase
                    end

                    3'b101: begin
                        case(instr[31:25])
                            7'b000_000_0: begin // SRL

                            end
                            7'b010_000_0: begin // SRA

                            end
                        endcase
                    end
                    3'b001: begin // SLL

                    end
                    3'b010: begin // SLT
                
                    end
                    3'b011: begin // SLTU

                    end
                    3'b100: begin // XOR

                    end
                    3'b110: begin // OR

                    end
                    3'b111: begin // AND

                    end
                endcase

            end
            7'b0010011 : begin // I-type

            end
            7'b0100011 : begin // S-type

            end
            7'b1100011 : begin // B-type
            
            end
        endcase
    end

endmodule