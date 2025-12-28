module forwarding_unit(forwardA, forwardB, rs1E, rs2E, rdM, rdW, regWriteM, regWriteW);
    
    input [4:0] rs1E, rs2E, rdM, rdW;
    input regWriteM, regWriteW;
    output reg [1:0] forwardA, forwardB;

always @(*) begin

    // ForwardA (for EX stage operand A)
    if ((rdM == rs1E) && (regWriteM) && (rs1E != 0))
        forwardA = 2'b10;
    else if ((rdW == rs1E) && (regWriteW) && (rs1E != 0))
        forwardA = 2'b01;
    else 
        forwardA = 2'b00;
end
always@(*) begin
    // ForwardB (for EX stage operand B)
    if ((rdM == rs2E) && (regWriteM) && (rs2E != 0))
        forwardB = 2'b10;
    else if ((rdW == rs2E) && (regWriteW) && (rs2E != 0))
        forwardB = 2'b01;
    else 
        forwardB = 2'b00;
end

endmodule

module forwarding_unit_tb;

reg  [4:0] rs1E, rs2E, rdM, rdW;
reg  regWriteM, regWriteW;
wire [1:0] forwardA, forwardB;

forwarding_unit dut (forwardA, forwardB, rs1E, rs2E, rdM, rdW, regWriteM, regWriteW);

initial begin
rs1E = 5'd3; rs2E = 5'd4; rdM  = 5'd0; rdW = 5'd0;
regWriteM = 0; regWriteW = 0; #10;

rs1E = 5'd5; rs2E = 5'd7; rdM  = 5'd5; rdW = 5'd0;
regWriteM = 1; regWriteW = 0;  #10;

rs1E = 5'd1; rs2E = 5'd8; rdM  = 5'd8; rdW = 5'd0;
regWriteM = 1; regWriteW = 0; #10;

rs1E = 5'd9; rs2E = 5'd3; rdM  = 5'd0; rdW = 5'd9;
regWriteM = 0; regWriteW = 1; #10;

rs1E = 5'd2; rs2E = 5'd10; rdM  = 5'd0; rdW = 5'd10;
regWriteM = 0; regWriteW = 1;  #10;

rs1E = 5'd12; rs2E = 5'd13; rdM  = 5'd12; rdW = 5'd12; 
regWriteM = 1; regWriteW = 1; #10;

rs1E = 5'd0; rs2E = 5'd0; rdM  = 5'd0; rdW = 5'd0;
regWriteM = 1; regWriteW = 1; #10;

$stop;
end

endmodule

