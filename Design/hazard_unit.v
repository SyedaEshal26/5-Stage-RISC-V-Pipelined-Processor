module hazard_unit ( pc_write, stallF, flushD, flushE, stallD, resultSrcE, branchTakenE, 
rdE, rs1D, rs2D); 

input [1:0]resultSrcE;
input branchTakenE;  
input  [4:0] rdE, rs1D, rs2D; 
output reg pc_write, stallF, flushD, flushE, stallD;

always @(*) begin
    
    pc_write  = 1'b1;
    stallF    = 1'b0;
    flushD    = 1'b0;
    flushE    = 1'b0;
    stallD    = 1'b0;

    if ((resultSrcE == 2'b01) && ( (rdE != 0) && ( (rdE == rs1D) | (rdE == rs2D) ) )) begin
        pc_write  = 1'b0;
        stallF  = 1'b1;   // hold IF/ID
        flushE  = 1'b1;   
        flushD =  1'b0;
        stallD  = 1'b1;   
    end

    if (branchTakenE) begin
        pc_write  = 1'b1;
        stallF  = 1'b0;   // do not hold IF/ID 
        flushD  = 1'b1;   // flush IF/ID 
        flushE  = 1'b1;   // flush ID/EX (convert to NOP)
        stallD  = 1'b0;
    end
end

endmodule


module hazard_unit_tb;

reg  [1:0] resultSrcE;
reg  branchTakenE;
reg  [4:0] rdE, rs1D, rs2D;
wire pc_write, stallF, flushD, flushE, stallD;

hazard_unit HU(pc_write, stallF, flushD, flushE, stallD, resultSrcE, branchTakenE, 
rdE, rs1D, rs2D);

initial begin
resultSrcE    = 2'b00;  branchTakenE  = 0;
rdE = 5'd3; rs1D = 5'd1; rs2D = 5'd2;  #10;

resultSrcE    = 2'b01;   branchTakenE  = 0;
rdE  = 5'd4; rs1D = 5'd4; rs2D = 5'd0; #10;

resultSrcE    = 2'b01;  branchTakenE  = 0;
rdE  = 5'd8; rs1D = 5'd1; rs2D = 5'd8; #10;

resultSrcE    = 2'b00;  branchTakenE  = 1;
rdE  = 5'd0; rs1D = 5'd0; rs2D = 5'd0; #10;

resultSrcE    = 2'b01; branchTakenE  = 1;
rdE  = 5'd5; rs1D = 5'd5; rs2D = 5'd0; #10;

$stop;
end
endmodule

   
