module pc (
    input logic [11:0] next_pc,
    input logic clk,
    input logic rstn,
    output logic [11:0] current_pc
);

    logic [11:0] pc_reg;

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            pc_reg <= '0;
        end else begin
            pc_reg <= next_pc;
        end
    end

    assign current_pc = pc_reg;

endmodule