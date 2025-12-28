module control_unit(branch,jump,regwrite,memwrite,alu_src,result_src,imm_src,aluop,opcode);
input [6:0]opcode;
output [1:0]aluop, imm_src,result_src;
output branch,jump,regwrite,memwrite,alu_src;
wire [10:0]controls;

assign {alu_src,result_src,imm_src,regwrite,memwrite,branch,jump,aluop} = controls;

assign controls =
    (opcode == 7'b0110011) ? 11'b0_00_00_1_0_0_0_10 : // R-type
    (opcode == 7'b0000011) ? 11'b1_01_00_1_0_0_0_00 : // Load (lw)
    (opcode == 7'b0100011) ? 11'b1_00_01_0_1_0_0_00 : // Store (sw)
    (opcode == 7'b1100011) ? 11'b0_00_10_0_0_1_0_01 : // Branch (beq/bne/blt/bge)
    (opcode == 7'b0010011) ? 11'b1_00_00_1_0_0_0_10 : // I-type (addi)
    (opcode == 7'b1101111) ? 11'b0_10_11_1_0_0_1_00 : // JAL
    (opcode == 7'b1100111) ? 11'b1_10_00_1_0_0_1_00 : // JALR
                             11'b0_00_00_0_0_0_0_00;  // default

endmodule

module control_unit_tb;
reg [6:0] opcode;
wire branch, regwrite, memwrite, alu_src,jump;
wire [1:0] imm_src, aluop, result_src;

control_unit C_UNIT(branch,jump,regwrite,memwrite,alu_src,result_src,imm_src,aluop,opcode);
initial begin
opcode = 7'b0110011; // R-type
#10; 
opcode = 7'b0000011; // Load (lw)
#10; 
opcode = 7'b0100011; // Store (sw)
#10; 
opcode = 7'b1100011;  // Branch (beq/bne/bge)
#10;
opcode = 7'b0010011; // I-type (addi)
#10; 
opcode = 7'b1111111; // Default (invalid)
#10; 
end
initial begin 
$monitor("time=%0t opcode=%b | branch=%b jump=%b regwrite=%b memwrite=%b alu_src=%b result_src=%b imm_src=%b aluop=%b",$time,
 opcode, branch, jump, regwrite, memwrite, alu_src, result_src, imm_src, aluop);
end
endmodule
