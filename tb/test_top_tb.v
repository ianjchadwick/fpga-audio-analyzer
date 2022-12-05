`timescale 1ns / 1ps

module test_top_tb();

reg clk, rst, 
    song_wr_en,
    ref_wr_en;
reg [14:0] sung_freq_in,
           ref_freq_in;

wire [14:0] song_dout,
            ref_dout;
wire [11:0] song_data_count,
            ref_data_count;
wire [3:0] score_avg;
wire song_valid, 
     song_full, 
     song_empty,
     ref_valid,
     ref_full,
     ref_empty,
     score_ready;

test_top UUT(.clk(clk),
            .rst(rst),
            .song_full(song_full),
            .song_din(sung_freq_in),
            .song_wr_en(song_wr_en),
            .song_empty(song_empty),
            .song_dout(song_dout),
            .song_valid(song_valid),
            .song_data_count(song_data_count),
            .ref_full(ref_full),
            .ref_din(ref_freq_in),
            .ref_wr_en(ref_wr_en),
            .ref_empty(ref_empty),
            .ref_dout(ref_dout),
            .ref_valid(ref_valid),
            .ref_data_count(ref_data_count),
            .score_avg(score_avg),
            .score_ready(score_ready));

always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
song_wr_en = 0;
sung_freq_in =0;
ref_freq_in = 14'd440;
#10;
rst = 0;
#10;
sung_freq_in = 14'd440;
song_wr_en = 1;
ref_wr_en = 1;
#10;
sung_freq_in = 14'd466;
song_wr_en = 1;
ref_wr_en = 1;
#10;
ref_wr_en = 0;
song_wr_en = 0;
end

endmodule
