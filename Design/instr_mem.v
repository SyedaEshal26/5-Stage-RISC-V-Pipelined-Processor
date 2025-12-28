module instr_mem (addr,inst);
input  [31:0] addr;
output reg [31:0] inst;
reg [7:0] mem [119:0];  
integer i;

initial begin
    // little-endian storage (lowest byte first)
    // addi x22,x0,0
    mem[0]  = 8'h13; mem[1]  = 8'h0B; mem[2]  = 8'h00; mem[3]  = 8'h00;
    // addi x23,x0,0
    mem[4]  = 8'h93; mem[5]  = 8'h0B; mem[6]  = 8'h00; mem[7]  = 8'h00;
    // addi x10,x0,10
    mem[8]  = 8'h13; mem[9]  = 8'h05; mem[10] = 8'hA0; mem[11] = 8'h00;
    // slli x24,x22,2
    mem[12] = 8'h13; mem[13] = 8'h1C; mem[14] = 8'h2B; mem[15] = 8'h00;
    // sw x22,512(x24)
    mem[16] = 8'h23; mem[17] = 8'h20; mem[18] = 8'h6C; mem[19] = 8'h21;
    // addi x22,x22,1
    mem[20] = 8'h13; mem[21] = 8'h0B; mem[22] = 8'h1B; mem[23] = 8'h00;
    // bne x22,x10,-12
    mem[24] = 8'he3; mem[25] = 8'h1a; mem[26] = 8'hab; mem[27] = 8'hfe;
    // addi x22,x0,0
    mem[28] = 8'h13; mem[29] = 8'h0B; mem[30] = 8'h00; mem[31] = 8'h00;
    // slli x24,x22,2
    mem[32] = 8'h13; mem[33] = 8'h1C; mem[34] = 8'h2B; mem[35] = 8'h00;
    // add x23,x22,x0
    mem[36] = 8'hb3; mem[37] = 8'h0b; mem[38] = 8'h0b; mem[39] = 8'h00;
    // slli x25,x23,2
    mem[40] = 8'h93; mem[41] = 8'h9C; mem[42] = 8'h2b; mem[43] = 8'h00;
    // lw x1,512(x24)
    mem[44] = 8'h83; mem[45] = 8'h20; mem[46] = 8'h0c; mem[47] = 8'h20;
    // lw x2,512(x25)
    mem[48] = 8'h03; mem[49] = 8'ha1; mem[50] = 8'h0c; mem[51] = 8'h20;
    // bge x1,x2,12
    mem[52] = 8'h63; mem[53] = 8'hd8; mem[54] = 8'h20; mem[55] = 8'h00;
    // add x5,x1,0
    mem[56] = 8'hb3; mem[57] = 8'h82; mem[58] = 8'h00; mem[59] = 8'h00;
    // sw x2,512(x24)
    mem[60] = 8'h23; mem[61] = 8'h20; mem[62] = 8'h2c; mem[63] = 8'h20;
    // sw x5,512(x25)
    mem[64] = 8'h23; mem[65] = 8'ha0; mem[66] = 8'h5c; mem[67] = 8'h20;
    // addi x23,x23,1
    mem[68] = 8'h93; mem[69] = 8'h8b; mem[70] = 8'h1b; mem[71] = 8'h00;
    // bne x23,x10,-28
    mem[72] = 8'he3; mem[73] = 8'h90; mem[74] = 8'hab; mem[75] = 8'hfe;
    // addi x22,x22,1
    mem[76] = 8'h13; mem[77] = 8'h0B; mem[78] = 8'h1B; mem[79] = 8'h00;
    // bne x22,x10,-40
    mem[80] = 8'he3; mem[81] = 8'h18; mem[82] = 8'hab; mem[83] = 8'hfc;

    for (i = 84; i <= 119; i = i + 4) begin
        mem[i]   = 8'h00;
        mem[i+1] = 8'h00;
        mem[i+2] = 8'h00;
        mem[i+3] = 8'h00;
    end
end

always @(addr)
inst = {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};
endmodule

module instr_mem_tb;
reg  [31:0] addr;
wire [31:0] inst;

instr_mem INST_MEM(addr,inst);

initial begin
$display("Time\tAddr\tInstruction");
$monitor("%0t\t%h\t%h", $time, addr, inst);

addr = 32'h0000_0000; #10;  
addr = 32'h0000_0004; #10; 
addr = 32'h0000_0018; #10;   
addr = 32'h0000_0008; #10;  
addr = 32'h0000_0024; #10;   
addr = 32'h0000_0014; #10;  
addr = 32'h0000_0010; #10; 
addr = 32'h0000_001C; #10;  
addr = 32'h0000_0020; #10;  
addr = 32'h0000_000C; #10;
addr = 32'h0000_0030; #10;  

$stop;
end
endmodule
