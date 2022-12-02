`timescale 1ns / 1ps

module tally_tb();
reg clk;
reg [3:0] score;
reg score_ready, reset;
wire [3:0] score_avg;

tally UUT(.clk(clk),
          .reset(reset),
          .score_ready(score_ready),
          .score(score),
          .score_avg(score_avg));

always #5 clk = ~clk;

initial begin
clk = 0;
score = 0;
score_ready = 0;
reset = 1;
#10
reset = 0;
score = 10;
score_ready = 1;
#10;
score_ready = 0;
#50
score = 7;
score_ready = 1;
#10;
score_ready = 0;

end

endmodule
