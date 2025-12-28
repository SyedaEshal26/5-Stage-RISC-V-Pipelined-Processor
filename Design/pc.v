module pc(clk,reset,pc_write,x,out);
input clk,reset,pc_write;
input [31:0]x;
output reg [31:0]out;

initial
out=0;

always @(posedge clk or posedge reset)
begin 
 if (reset)
 out <= 32'd0;
 else if (pc_write)
 out <= x;
end
endmodule

module pc_tb;

reg clk, reset, pc_write;
reg [31:0] x;
wire [31:0] out;

pc PC(clk, reset, pc_write, x, out);

initial clk = 0;
always #5 clk = ~clk;

initial begin

    reset = 1;
    pc_write = 0;
    x = 0;
    #10 reset = 0;     
    #5  pc_write = 1;
        x = 32'd4;
    #10 pc_write = 1;
        x = 32'd8;
    #10 pc_write = 0;
        x = 32'd12;  
    #20 reset = 1;
    #10 reset = 0;

    #20 $stop;
end

// Monitor
initial begin
    $monitor("time=%0t | reset=%b | pc_write=%b | x=%h | out=%h",
              $time, reset, pc_write, x, out);
end

endmodule

