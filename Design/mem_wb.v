module mem_wb (regWriteW, resultSrcW, aluResultW, readDataW, rdW, pc_4W, clk, reset, regWriteM, resultSrcM, aluResultM,
readDataM, rdM, pc_4M);

    output reg        regWriteW;
    output reg [1:0]  resultSrcW;
    output reg [31:0] aluResultW, readDataW, pc_4W;
    output reg [4:0]  rdW;
    input clk, reset, regWriteM;
    input [1:0] resultSrcM;
    input [31:0] aluResultM, readDataM, pc_4M;
    input [4:0] rdM;

   always @(posedge clk or posedge reset) begin
        if (reset) begin
            regWriteW  <= 0;
            resultSrcW <= 0;
            aluResultW <= 0;
            readDataW  <= 0;
            rdW        <= 0;
            pc_4W      <= 0;
        end else begin
            regWriteW  <= regWriteM;
            resultSrcW <= resultSrcM;
            aluResultW <= aluResultM;
            readDataW  <= readDataM;
            rdW        <= rdM;
            pc_4W      <= pc_4M;
        end
    end

endmodule

module mem_wb_tb;

    // Clock and control signals
    reg clk, reset, memwrite, regWriteM;
    reg [1:0] resultSrcM;
    reg [31:0] aluResultM, writeDataM, readDataM, pc_4M;
    reg [4:0] rdM;
    reg [31:0] addr;
    wire regWriteW;
    wire [1:0] resultSrcW;
    wire [31:0] aluResultW, readDataW, rd, pc_4W; 
    wire [4:0] rdW;

data_mem MEM(rd,clk,memwrite,addr,writeDataM);

assign readDataM = rd;

mem_wb PIPE_WB(regWriteW, resultSrcW, aluResultW, readDataW, rdW, pc_4W, clk, reset, regWriteM, resultSrcM, aluResultM,
readDataM, rdM, pc_4M);

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; memwrite = 0;
        regWriteM = 0; resultSrcM = 0; aluResultM = 0; writeDataM = 0; rdM = 0; addr = 0;

        #10 reset = 0;

        // Test 1: Write to memory and propagate to WB
        regWriteM = 1; resultSrcM = 2'b01; aluResultM = 32'hAAAA_BBBB; writeDataM = 32'h1234_5678; rdM = 5'd10;
        addr = 0; memwrite = 1;
        #10 memwrite = 0; addr = 0;

        #10;

        regWriteM = 0; resultSrcM = 2'b10; aluResultM = 32'hFFFF_0000; writeDataM = 32'h8765_4321; rdM = 5'd5;
        addr = 4; memwrite = 1; 
        #10 memwrite = 0;#10;

        // Test 3: Flush MEM/WB, outputs reset
        reset = 1;
        regWriteM = 1; resultSrcM = 2'b11; aluResultM = 32'hDEAD_BEEF; writeDataM = 32'hFEED_FACE; rdM = 5'd31;
        addr = 8; memwrite = 0;
        #10 

        #1000;
        $stop;
    end

    // Monitor
    initial begin
        $monitor("T=%0t | regWriteW=%b | resultSrcW=%b | aluResultW=%h | readDataW=%h | rdW=%d | MEM rd=%h",
                 $time, regWriteW, resultSrcW, aluResultW, readDataW, rdW, readDataM);
    end

endmodule
