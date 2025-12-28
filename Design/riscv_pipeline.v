module riscv_pipeline(clk, rst);

input clk, rst;
wire clk_d;
// --- IF Stage ---
wire [31:0] pcF, pc_out, instrF, pc_4F, pc_tarE;
wire pcSrcE, stallF;

// --- IF/ID Pipeline Register ---
wire [31:0] pcD, instrD, pc_4D;
wire stallD, flushD;

// --- ID Stage ---
wire [31:0] rd1D, rd2D, immD;
wire [4:0] rs1D, rs2D, rdD;
wire regwriteD, memwriteD, aluSrcD, branchD, jumpD;
wire [1:0] immSrcD, resultSrcD;
wire [2:0] aluControlD, fun3D;
wire [6:0] opcodeD;
wire fun7D;

// --- Hazard Detection ---
wire flushE, branchTakenE, pc_write;

// --- ID/EX Pipeline Register ---
wire regwriteE, memwriteE, aluSrcE, branchE, jumpE;
wire [1:0] resultSrcE;
wire [2:0] aluControlE, fun3E;
wire [31:0] rd1E, rd2E, immE, pcE, pc_4E;
wire [4:0] rs1E, rs2E, rdE;

// --- Execution Stage ---
wire [31:0] aluResultE, writeDataE, SrcAE, SRCBE, SrcBE;
wire zeroE, ltE;
wire [1:0] forwardAE, forwardBE;

// --- EX/MEM Pipeline Register ---
wire regwriteM, memwriteM;
wire [1:0] resultSrcM;
wire [31:0] aluResultM, writeDataM, pc_4M;
wire [4:0] rdM;

// --- Memory Stage ---
wire [31:0] readDataM;

// --- MEM/WB Pipeline Register ---
wire regwriteW;
wire [1:0] resultSrcW;
wire [31:0] aluResultW, readDataW, pc_4W;
wire [4:0] rdW;

// --- Write-back Stage ---
wire [31:0] resultW;
wire [31:0] wdw;

clk_div clkd(clk,rst,clk_d);

//FETCH

mux MUX_F(pc_out, pcSrcE, pc_4F, pc_tarE);

pc PC_F(clk_d, rst, pc_write, pc_out, pcF);

instr_mem IM_F(pcF, instrF);

adder ADDER_F(pc_4F, pcF, 32'd4);

if_id IF_ID(pcD, instrD, pc_4D, clk_d, rst, stallD, flushD, pcF, instrF, pc_4F);

// DECODE
assign opcodeD = instrD[6:0];
assign fun3D = instrD[14:12];
assign fun7D = instrD[30];
assign rs1D = instrD[19:15];
assign rs2D = instrD[24:20];
assign rdD = instrD[11:7];

cu CU_D(aluSrcD, resultSrcD, regwriteD, memwriteD, immSrcD, aluControlD, branchD, jumpD, opcodeD, fun3D ,fun7D);

reg_file RF_D(rd1D, rd2D, rs1D, rs2D, rdW, wdw, regwriteW, clk_d);

imm_ext IMMEXT_D(immD, immSrcD, instrD);

assign branchTakenE = pcSrcE;
hazard_unit HAZARD(pc_write, stallF, flushD, flushE, stallD, resultSrcE, branchTakenE, rdE, rs1D, rs2D);

id_ex ID_EX(regwriteE, memwriteE, aluSrcE, resultSrcE, aluControlE, fun3E, rd1E, rd2E, immE, pcE, rs1E, rs2E, rdE, branchE, jumpE, pc_4E, clk_d, 
rst, flushE, regwriteD, memwriteD, aluSrcD, resultSrcD, aluControlD, fun3D, rd1D, rd2D, immD, pcD, rs1D,rs2D, rdD, branchD, jumpD, pc_4D); 

// EXECUTE
forwarding_unit FRWD_E(forwardAE, forwardBE, rs1E, rs2E, rdM, rdW, regwriteM, regwriteW);
   
mux3 srcAE(SrcAE, forwardAE, rd1E, wdw, aluResultM);

mux3 srcBE(SRCBE, forwardBE, rd2E, wdw, aluResultM);

mux MUX_E(SrcBE, aluSrcE, SRCBE, immE);

alu ALU_E(aluResultE, zeroE, ltE, SrcAE, SrcBE, aluControlE);

adder ADDER_E(pc_tarE, pcE, immE);

assign pcSrcE =
    ((branchE && fun3E == 3'b000 && zeroE)|jumpE)   ||   // BEQ
    ((branchE && fun3E == 3'b001 && !zeroE)|jumpE)  ||   // BNE
    ((branchE && fun3E == 3'b100 && ltE)|jumpE)   ||   // BLT
    ((branchE && fun3E == 3'b101 && !ltE)|jumpE);        // BGE
assign writeDataE = SRCBE;

ex_mem EX_MEM(regwriteM, memwriteM, resultSrcM, aluResultM, writeDataM, rdM, pc_4M, clk_d, rst, regwriteE, memwriteE,
resultSrcE, aluResultE, writeDataE, rdE, pc_4E);

// MEMORY STAGE 
data_mem MEMORY(readDataM, clk_d, memwriteM, aluResultM, writeDataM);

mem_wb MEM_WB(regwriteW, resultSrcW, aluResultW, readDataW, rdW, pc_4W, clk_d, rst, regwriteM, resultSrcM, aluResultM,
readDataM, rdM, pc_4M);

// WRITE BACK 
mux3 WRITE_BACK(resultW, resultSrcW, aluResultW, readDataW, pc_4W);
assign wdw = resultW;

endmodule

