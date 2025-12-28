module alu(result, zero, lt, a, b, alu_control);

input  [31:0] a, b;
input  [2:0]  alu_control;   
output reg [31:0] result;
output reg zero, lt;

always @(*) begin
    case (alu_control)
        3'd0: result = a + b;                          // ADD
        3'd1: result = a - b;                          // SUB, BEQ, BNE
        3'd2: result = a & b;                          // AND
        3'd3: result = a | b;                          // OR
        3'd4: result = $signed(a) < $signed(b) ? 32'd1 : 32'd0; // SLT
        3'd5: result = a << b[4:0];                    // SLL
        3'd6: result = a >> b[4:0];                    // SRL
        3'd7: result = $signed(a) >>> b[4:0];          // SRA
        default: result = 32'h00000000;
    endcase
    
  //  zero = (result == 32'b0);
    zero = (a == b);
    lt   = ($signed(a) < $signed(b));
end

endmodule

module alu_tb;

reg  [31:0] a, b;
reg  [2:0] alu_control;
wire [31:0] result;
wire zero;

alu ALU(result,zero,lt,a,b,alu_control);

initial begin

    // ADD
    a = 10; b = 5; alu_control = 3'd0; #5
    // SUB
    a = 10; b = 5; alu_control = 3'd1; #5
    // AND
    a = 10; b = 5; alu_control = 3'd2; #5
    // OR
    a = 10; b = 5; alu_control = 3'd3; #5
    // SLT
    a = -3; b = 5; alu_control = 3'd4; #5
    // SLL
    a = 32'h0000_0001; b = 3; alu_control = 3'd5; #5
    // SRL
    a = 32'h0000_0010; b = 1; alu_control = 3'd6; #5
    // SRA
    a = -16; b = 2; alu_control = 3'd7; #5
    // Compare equal for zero flag
    a = 10; b = 10; alu_control = 3'd1; #5;

#50000;
$stop;
end

initial begin
$monitor("time=%0t a=%0d b=%0d alu_control=%0d result=%0d zero=%b",$time, a, b, alu_control, result, zero);
end
endmodule
