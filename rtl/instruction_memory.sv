module instruction_memory (
    input logic [31:0] current_pc,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:1023];

    initial begin
        $readmemh("instructions.txt", mem);

    end


    always_comb begin
        instruction = mem[current_pc[11:2]];
    end
endmodule