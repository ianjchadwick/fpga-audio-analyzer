`timescale 1ns / 1ps

module test_top_tb();

reg clk, rst, 
    song_wr_en,
    ref_wr_en,
    BTNC;
reg [14:0] sung_freq_in,
           ref_freq_in;

wire [3:0] score_avg;


test_top UUT(.clk(clk),
             .BTNC(BTNC),
            .score_avg(score_avg)
            );

always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
BTNC = 0;
#10;
rst = 0;
BTNC = 1;
#10;
BTNC = 0;
end

endmodule
