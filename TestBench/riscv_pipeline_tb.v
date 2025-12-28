module riscv_pipeline_tb;

    reg clk, rst;
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        rst = 1;
        #15 rst = 0;
        #40700;
        $stop;
    end

    // Instantiate the pipeline
    riscv_pipeline PIPELINE(
        .clk(clk),
        .rst(rst)
    );

    // Print all pipeline signals every clock edge
    always @(posedge clk) begin
        $display("T=%0t", $time);

        $display("IF stage: pcF=%h instrF=%h pc_4F=%h pc_tarE=%h pcSrcE=%b stallF=%b",
                 PIPELINE.pcF, PIPELINE.instrF, PIPELINE.pc_4F, PIPELINE.pc_tarE, PIPELINE.pcSrcE, PIPELINE.stallF);

        $display("ID stage: pcD=%h instrD=%h pc_4D=%h stallD=%b flushD=%b",
                 PIPELINE.pcD, PIPELINE.instrD, PIPELINE.pc_4D, PIPELINE.stallD, PIPELINE.flushD);

        $display("Regs: rs1D=%0d rs2D=%0d rdD=%0d rd1D=%h rd2D=%h immD=%h",
                 PIPELINE.rs1D, PIPELINE.rs2D, PIPELINE.rdD, PIPELINE.rd1D, PIPELINE.rd2D, PIPELINE.immD);

        $display("Ctrl: regwriteD=%b memwriteD=%b aluSrcD=%b branchD=%b jumpD=%b aluControlD=%b resultSrcD=%b",
                 PIPELINE.regwriteD, PIPELINE.memwriteD, PIPELINE.aluSrcD, PIPELINE.branchD, PIPELINE.jumpD,
                 PIPELINE.aluControlD, PIPELINE.resultSrcD);

        $display("EX stage: rdE=%0d rs1E=%0d rs2E=%0d rd1E=%h rd2E=%h immE=%h aluControlE=%b aluSrcE=%b branchE=%b jumpE=%b resultSrcE=%b pcE=%h pc_4E=%h",
                 PIPELINE.rdE, PIPELINE.rs1E, PIPELINE.rs2E, PIPELINE.rd1E, PIPELINE.rd2E, PIPELINE.immE,
                 PIPELINE.aluControlE, PIPELINE.aluSrcE, PIPELINE.branchE, PIPELINE.jumpE, PIPELINE.resultSrcE,
                 PIPELINE.pcE, PIPELINE.pc_4E);

        $display("ALU: SrcAE=%h SrcBE=%h aluResultE=%h zeroE=%b forwardAE=%b forwardBE=%b pc_tarE=%h pcSrcE=%b",
                 PIPELINE.SrcAE, PIPELINE.SrcBE, PIPELINE.aluResultE, PIPELINE.zeroE,
                 PIPELINE.forwardAE, PIPELINE.forwardBE, PIPELINE.pc_tarE, PIPELINE.pcSrcE);

        $display("MEM stage: rdM=%0d aluResultM=%h writeDataM=%h regwriteM=%b memwriteM=%b resultSrcM=%b pc_4M=%h readDataM=%h",
                 PIPELINE.rdM, PIPELINE.aluResultM, PIPELINE.writeDataM, PIPELINE.regwriteM,
                 PIPELINE.memwriteM, PIPELINE.resultSrcM, PIPELINE.pc_4M, PIPELINE.readDataM);

        $display("WB stage: rdW=%0d aluResultW=%h readDataW=%h regwriteW=%b resultSrcW=%b pc_4W=%h resultW=%h wdw=%h",
                 PIPELINE.rdW, PIPELINE.aluResultW, PIPELINE.readDataW, PIPELINE.regwriteW,
                 PIPELINE.resultSrcW, PIPELINE.pc_4W, PIPELINE.resultW, PIPELINE.wdw);

        $display("---------------------------------------------------------------");
    end

endmodule


