module if_id (pcD, instrD, pc_4D, clk,rst, stallD, flushD, pcF, instrF, pc_4F);

    output reg [31:0] pcD, instrD, pc_4D;
    input clk, rst, stallD, flushD;
    input [31:0] pcF, instrF, pc_4F;

always @(posedge clk or posedge rst) begin
    if (rst | flushD) begin
        pcD    <= 32'b0;
        instrD <= 32'b0;
        pc_4D  <= 32'b0;
    end 
    else if (stallD) begin
        pcD    <= pcD;
        instrD <= instrD;
        pc_4D  <= pc_4D;
    end
    else begin
        pcD    <= pcF;
        instrD <= instrF;
        pc_4D  <= pc_4F;
    end
end

endmodule

module if_id_tb();

reg clk, rst, pc_write, pc_src;
reg stallD, flushD;
reg [31:0] pc_tar;
wire [31:0] instrF, pcF, pc_4;
wire [31:0] instrD, pcD, pc_4D;


inst_fetch IF_STAGE (instrF,pcF,pc_4,clk,rst,pc_write,pc_tar,pc_src);

if_id IF_ID_STAGE(pcD, instrD, pc_4D, clk,rst, stallD, flushD, pcF, instrF, pc_4);


initial clk = 0;
always #5 clk = ~clk;  

initial begin
    
    rst = 1;
    pc_src = 0;
    pc_tar = 32'h0000_0010;
    pc_write = 0;
    stallD = 0;
    flushD = 0;
    #10;

    rst = 0; 
    pc_write = 1; #20;

    pc_src = 1;
    #10;
    pc_src = 0;
    #20;

    stallD = 1;  #20;
    stallD = 0;

    flushD = 1;  #10;
    flushD = 0;  #30;

    pc_write = 0;
    #20;
    pc_write = 1;

    #500;
    $stop;
end

initial begin
$monitor("T=%0t | rst=%b | pcF=%h | instrF=%h | pcD=%h | instrD=%h | pc_4D=%h | pc_src=%b | stallD=%b | flushD=%b | pc_write=%b",
         $time, rst, pcF, instrF, pcD, instrD, pc_4D, pc_src, stallD, flushD, pc_write);

end
endmodule

