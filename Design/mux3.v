module mux3 (y, sel, a, b, c);
   
    output reg [31:0] y;
    input [1:0] sel;
    input [31:0] a, b, c;
   
    always @(*) begin
        case (sel)
            2'b00: y = a;   // normal data
            2'b01: y = b;   // forwarded from WB
            2'b10: y = c;   // forwarded from MEM
            default: y = 32'b0;
        endcase
    end
endmodule

module mux3_tb;

reg  [31:0] a, b, c;
reg  [1:0]  sel;
wire [31:0] y;

mux3 MUX3(y,sel,a,b,c);

initial begin
    a = 32'hAAAA_AAAA; 
    b = 32'hBBBB_BBBB;
    c = 32'hCCCC_CCCC;
    sel = 2'b00; #10;
    sel = 2'b01; #10;
    sel = 2'b10; #10;
    sel = 2'b11; #10;
    $stop;
end
initial begin
    $monitor("t=%0t | sel=%b | a=%h | b=%h | c=%h | y=%h",
              $time, sel, a, b, c, y);
end

endmodule
