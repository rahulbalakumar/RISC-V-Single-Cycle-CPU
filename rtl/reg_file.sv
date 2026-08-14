module reg_file (
    input logic clk,
    input logic [31:0] data_in,
    input logic [4:0] rd,
    input logic wr,
    input logic [4:0] rs1, rs2,
    output logic [31:0] data_out1, data_out2
);

    logic [31:0] regs [0:31];

    always_ff @(posedge clk) begin
        if (wr) begin
            regs[rd] <= data_in;
        end 
    end

    always_comb begin
        if (rs1 == '0) begin
            data_out1 = '0;
        end else begin
            data_out1 = regs[rs1];
        end

        if (rs2 == '0) begin
            data_out2 = '0;
        end else begin 
            data_out2 = regs[rs2];
        end
    end
    
endmodule
