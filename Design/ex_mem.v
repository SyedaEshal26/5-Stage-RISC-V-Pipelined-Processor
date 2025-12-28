module ex_mem (regWriteM, memWriteM, resultSrcM, aluResultM, writeDataM, rdM, pc_4M, clk, reset, regWriteE, memWriteE, resultSrcE,
aluResultE, writeDataE, rdE, pc_4E);

    output reg        regWriteM, memWriteM;
    output reg [1:0]  resultSrcM;
    output reg [31:0] aluResultM, writeDataM, pc_4M;
    output reg [4:0]  rdM;
    input             clk, reset, regWriteE, memWriteE;
    input [1:0]       resultSrcE;
    input [31:0]      aluResultE, writeDataE, pc_4E;
    input [4:0]       rdE;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        regWriteM  <= 0;
        memWriteM  <= 0;
        resultSrcM <= 0;
        aluResultM <= 0;
        writeDataM <= 0;
        rdM        <= 0;
        pc_4M      <= 0;
    end else begin
        regWriteM  <= regWriteE;
        memWriteM  <= memWriteE;
        resultSrcM <= resultSrcE;
        aluResultM <= aluResultE;
        writeDataM <= writeDataE;
        rdM        <= rdE;
        pc_4M      <= pc_4E;
    end
end
endmodule

module ex_mem_tb;

    reg clk, reset, aluSrcE, branchE, jumpE, regWriteM_in, regWriteW, regWriteE, memWriteE;
    reg [31:0] rd1E, rd2E, immE, pcE, aluResultM_in, resultW, pc_4E;
    reg [4:0] rs1E, rs2E, rdE, rdM, rdW;
    reg [2:0] aluControlE;
    reg [1:0] resultSrcE;
    wire [31:0] aluResultE, writeDataE, op_a, op_b, pc_target, aluResultM, writeDataM, pc_4M;
    wire zeroE, pcSrcE, regWriteM, memWriteM;
    wire [1:0] forwardAE, forwardBE, resultSrcM;
    wire [4:0] rdM_out;

execution_unit EX ( clk, rd1E, rd2E, immE, pcE, rs1E, rs2E, rdE, rdM, rdW, aluControlE, aluSrcE,
regWriteM_in, regWriteW, aluResultM_in, resultW, aluResultE, writeDataE, zeroE, forwardAE, forwardBE,
op_a, op_b, pc_target, branchE, jumpE, pcSrcE);

ex_mem PIPE ( regWriteM, memWriteM, resultSrcM, aluResultM, writeDataM, rdM_out, pc_4M, clk, reset,
regWriteE, memWriteE, resultSrcE, aluResultE, writeDataE, rdE, pc_4E );

initial clk = 0;
always #5 clk = ~clk;

initial begin
reset = 1; rd1E = 0; rd2E = 0; immE = 0; pcE = 32'h1000; rs1E = 0; rs2E = 0; rdE = 0;
aluSrcE = 0; aluControlE = 3'b000; branchE = 0; jumpE = 0; regWriteM_in = 0; regWriteW = 0;
aluResultM_in = 0; resultW = 0; regWriteE = 0; memWriteE = 0; resultSrcE = 0; pc_4E = 32'h1004;
#12 reset = 0;

aluSrcE = 1; aluControlE = 3'b000; rd1E = 32'd10; immE = 32'd7; rd2E = 32'd0; rs1E = 5'd1;
rs2E = 5'd2; rdE = 5'd10; regWriteE = 1; memWriteE = 0; resultSrcE = 2'b01; #10;
        
aluSrcE = 0; aluControlE = 3'b001; rd1E = 32'h1111_1111; rd2E = 32'h0000_0001; rs1E = 5'd1;
rs2E = 5'd2; regWriteM_in = 1; rdM = 5'd1; rdE = 5'd12; aluResultM_in = 32'hABCD_ABCD;
regWriteE = 1; memWriteE = 1; resultSrcE = 2'b10; #10;

reset = 1; #10 reset = 0; #20 
$stop;
end
initial begin
    $monitor("T=%0t | ALU_E=%h | WD_E=%h | ALU_M=%h | WD_M=%h | rdM=%d | pc4=%h",
    $time, aluResultE, writeDataE, aluResultM, writeDataM, rdM_out, pc_4M);
end
endmodule

