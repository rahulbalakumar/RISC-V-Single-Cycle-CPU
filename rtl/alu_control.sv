module alu_control(
    input logic [31:0] instr,
    output logic [3:0] alu_control
);
        //     alu_control
        // ADD      0000
        // SUB      0001
        // SLL      0010
        // SLT      0011
        // SLTU     0100
        // XOR      0101
        // SRL      0110
        // SRA      0111
        // OR       1000
        // AND      1001
    always_comb begin                                  
        case(instr[6:0])
            7'b0110011 : begin // R-type
                case(instr[14:12])
                    3'b000: begin // 
                        case(instr[31:25]) 
                            7'b000_000_0: begin // ADD
                                alu_control = 4'b0000;
                            end
                            7'b010_000_0: begin // SUB
                                alu_control = 4'b0001;
                            end 
                            default: begin
                                alu_control = 4'b0000; // ADD
                            end
                        endcase
                    end

                    3'b101: begin
                        case(instr[31:25])
                            7'b000_000_0: begin // SRL
                                alu_control = 4'b0110;
                            end
                            7'b010_000_0: begin // SRA
                                alu_control = 4'b0111;
                            end
                            default: begin
                                alu_control = 4'b0000; // ADD
                            end
                        endcase
                    end
                    3'b001: begin // SLL
                        alu_control = 4'b0010;
                    end
                    3'b010: begin // SLT
                        alu_control = 4'b0011;
                    end
                    3'b011: begin // SLTU
                        alu_control = 4'b0100;
                    end
                    3'b100: begin // XOR
                        alu_control = 4'b0101;
                    end
                    3'b110: begin // OR
                        alu_control = 4'b1000;
                    end
                    3'b111: begin // AND
                        alu_control = 4'b1001;
                    end
                    default: begin
                        alu_control = 4'b0000; // ADD
                    end
                endcase

            end
            7'b0010011 : begin // I-type
                case(instr[14:12]) 
                    3'b001: begin // SLLI
                        alu_control = 4'b0010;
                    end
                    3'b101: begin
                        case(instr[31:25])
                            7'b000_000_0: begin // SRLI
                                alu_control = 4'b0110;
                            end
                            7'b010_000_0: begin // SRAI
                                alu_control = 4'b0111;
                            end
                            default: begin
                                alu_control = 4'b0000; // ADD
                            end
                        endcase
                    end
                    3'b000: begin // ADDI
                        alu_control = 4'b0000;
                    end
                    3'b010: begin // SLTI
                        alu_control = 4'b0011;
                    end
                    3'b011: begin // SLTIU
                        alu_control = 4'b0100;
                    end
                    3'b100: begin // XORI
                        alu_control = 4'b0101;
                    end
                    3'b110: begin // ORI
                        alu_control = 4'b1000;
                    end
                    3'b111: begin // ANDI
                        alu_control = 4'b1001;
                    end
                    default: begin
                        alu_control = 4'b0000; // ADD
                    end
                endcase

            end
            7'b0100011 : begin // S-type
                alu_control = 4'b0000; // ADD

            end
            7'b1100011 : begin // B-type
                alu_control = 4'b0001;
            end

            default: begin
                alu_control = 4'b0000; // ADD
            end
        endcase
    end

endmodule