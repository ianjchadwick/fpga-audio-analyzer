`timescale 1ns / 1ps

module comparison_tb();

reg clk;
reg enable; 
reg start;              
reg [14:0] sung_freq_in;
reg [14:0] ref_freq_in;
wire [3:0]score;

comparison UUT (.clk(clk),
                .enable(enable), 
                .start(start),
                .sung_freq_in(sung_freq_in),
                .ref_freq_in(ref_freq_in),
                .score(score));

always #5 clk = ~clk;   
                
initial 
begin
clk = 0;
enable = 1;
ref_freq_in = 15'd432; //alternate tuning for middle A (A4)
sung_freq_in = 15'd880; //A5
start = 1;              //want score = 10
#10;
start =0;
#50;
ref_freq_in = 15'd440; //A4
sung_freq_in = 15'd880; //A5
start = 1;              //want score = 10
#10;
start = 0;
#50;
ref_freq_in = 15'd440; //A4
sung_freq_in = 15'd493; //B4
start = 1;              //want score = 5
#10;
start = 0;
#50;
ref_freq_in = 15'd440; //A4
sung_freq_in = 15'd466; //A4#
start = 1;              //want score = 7
#10;
start = 0;
#50;
ref_freq_in = 15'd440; //A4
sung_freq_in = 15'd466; //A4#
start = 1;              //want score = 7
#10;
start = 0;
end
endmodule
