`timescale 1ns / 1ps

module tally(
    input clk,
          score_ready, 
          reset,
    input [3:0] score,
    output reg [3:0] score_avg);

reg [63:0] score_tally = 32'd0;
reg [23:0] count       = 24'd0;

always@(posedge clk) begin
    if(reset)
        begin
            score_tally = 32'd0;
            count       = 24'd0;
        end
    else
        begin
            if(score_ready)
                begin
                    score_tally = score_tally + score;
                    count = count +1; 
                end
            else
                begin
                    score_tally = score_tally;
                    count = count;
                end
            if (count != 24'd0)
                score_avg = score_tally / count;
            else
                score_avg = 4'd0;
        end
end
endmodule
