module id_ex (regWriteE, memWriteE, aluSrcE, resultSrcE,  aluControlE, fun3E, rd1E, rd2E, immE, pcE, rs1E, rs2E, rdE, 
branchE, jumpE, pc_4E, clk, reset, flushE, regWriteD, memWriteD, aluSrcD, resultSrcD, aluControlD, fun3D, rd1D, rd2D, immD, 
pcD, rs1D, rs2D, rdD, branchD, jumpD, pc_4D);

    output reg        regWriteE, memWriteE, aluSrcE, branchE, jumpE;
    output reg [1:0]  resultSrcE;
    output reg [2:0]  aluControlE, fun3E;
    output reg [31:0] rd1E, rd2E, immE, pcE, pc_4E;
    output reg [4:0]  rs1E, rs2E, rdE;
    input             clk, reset, flushE, regWriteD, memWriteD, aluSrcD, branchD, jumpD;
    input [1:0]       resultSrcD;
    input [2:0]       aluControlD, fun3D;
    input [31:0]      rd1D, rd2D, immD, pcD, pc_4D;
    input [4:0]       rs1D, rs2D, rdD;
  
    always @(posedge clk or posedge reset) begin
        if (reset | flushE) begin
            regWriteE  <= 1'b0;
            memWriteE  <= 1'b0;
            aluSrcE    <= 1'b0;
            resultSrcE <= 2'b00;
            aluControlE<= 3'b000;
            fun3E      <= 3'b000;
            rd1E       <= 32'b0;
            rd2E       <= 32'b0;
            immE       <= 32'b0;
            pcE        <= 32'b0;
            rs1E       <= 5'b0;
            rs2E       <= 5'b0;
            rdE        <= 5'b0;
            branchE    <= 1'b0;
            jumpE      <= 1'b0;
            pc_4E      <= 32'b0;
        end else begin
            regWriteE  <= regWriteD;
            memWriteE  <= memWriteD;
            aluSrcE    <= aluSrcD;
            resultSrcE <= resultSrcD;
            aluControlE<= aluControlD;
            fun3E      <= fun3D;
            rd1E       <= rd1D;
            rd2E       <= rd2D;
            immE       <= immD;
            pcE        <= pcD;
            rs1E       <= rs1D;
            rs2E       <= rs2D;
            rdE        <= rdD;
            branchE    <= branchD;
            jumpE      <= jumpD;
            pc_4E      <= pc_4D;
        end
    end

endmodule

module id_ex_tb;

    reg clk;
    reg reset;
    reg regWriteW;             // write-back stage regWrite (for reg_file)
    reg [31:0] instr;
    reg [31:0] wdW;
    reg [4:0] rdW;
    wire [31:0] rd1D, rd2D, immD;
    wire [4:0] rs1D, rs2D, rdD;
    wire [6:0] opcodeD;
    wire [2:0] aluControlD, fun3D;
    wire fun7D, regWriteD, memWriteD, aluSrcD, branchD, jumpD;
    wire [1:0] immSrcD, resultSrcD;
    wire regWriteE, memWriteE, aluSrcE, branchE, jumpE;
    wire [1:0] resultSrcE;
    wire [2:0] aluControlE;
    wire [31:0] rd1E, rd2E, immE, pcE;
    wire [4:0] rs1E, rs2E, rdE;
    reg flushE;

    localparam INSTR_ADD  = 32'b0000000_00011_00010_000_00001_0110011; // add x1, x2, x3
    localparam INSTR_SUB  = 32'b0100000_00110_00101_000_00100_0110011; // sub x4, x5, x6
    localparam INSTR_SLL  = 32'b0000000_01001_01000_001_00111_0110011; // sll x7, x8, x9
    localparam INSTR_SLT  = 32'b0000000_01100_01011_010_01010_0110011; // slt x10,x11,x12
    localparam INSTR_LW   = 32'b000000000100_00010_010_00001_0000011; // lw x1,4(x2)
    localparam INSTR_SW   = 32'b0000000_00011_00100_010_01000_0100011; // sw x3,8(x4)
    localparam INSTR_BEQ  = 32'b0000000_00110_00101_000_00000_1100011; // beq x5,x6,offset

    inst_decode DEC ( clk,instr,regWriteD,memWriteD,aluSrcD,resultSrcD,aluControlD,immSrcD,branchD,jumpD,rd1D,rd2D,
    immD,opcodeD,fun3D,fun7D,wdW,rdW,regWriteW,rs1D,rs2D,rdD);
       
    id_ex ID_EX (regWriteE, memWriteE, aluSrcE, resultSrcE,  aluControlE, fun3E, rd1E, rd2E, immE, pcE, rs1E, rs2E, rdE, 
branchE, jumpE, pc_4E, clk, reset, flushE, regWriteD, memWriteD, aluSrcD, resultSrcD, aluControlD, fun3D, rd1D, rd2D, immD, 
pcD, rs1D, rs2D, rdD, branchD, jumpD, pc_4D);

    initial clk = 0;
    always #5 clk = ~clk; // 10 ns period

    initial begin

        reset = 1;
        regWriteW = 0;
        wdW = 32'h0;
        rdW = 5'h0;
        flushE = 0;
        instr = 32'h0000_0000;
        #12;             

        reset = 0;
       
        instr = INSTR_ADD;
        #10; 

        instr = INSTR_SUB;
        #10; 

        instr = INSTR_SLL;
        #10; 

        instr = INSTR_LW;
        #10; 

        instr = INSTR_SW;
        #10; 

        instr = INSTR_BEQ;
        #10;  

        instr = INSTR_ADD;
        #2;      
        flushE = 1;
        #10;

        instr = INSTR_ADD;
        #10; 
        $stop;
    end

   initial begin
        $monitor("T=%0t | instr=%h | decode: rdD=%0d rs1D=%0d rs2D=%0d aluCtrlD=%b aluSrcD=%b memWr=%b regWr=%b | id_ex.rdE=%0d immE=%h",
                 $time, instr, rdD, rs1D, rs2D, aluControlD, aluSrcD, memWriteD, regWriteD, rdE, immE);
    end

endmodule
