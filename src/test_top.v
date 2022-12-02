`timescale 1ns / 1ps

module test_top(
input clk, 
      rst, 
      song_wr_en,
      ref_wr_en,
input [14:0] song_din, //15 bits in Hz
             ref_din,
output song_full, 
       song_empty, 
       song_valid,
       ref_full,
       ref_empty,
       ref_valid,
       score_ready,
output [11:0] song_data_count,
              ref_data_count,
output [14:0] song_dout,
              ref_dout,
output [ 3:0] score_avg);

reg enable = 1'b1;

wire rd_en;

wire [3:0] score;

assign valid = song_valid & ref_valid;

fifo_generator_0 song_fifo (.clk(clk),
                            .srst(rst),
                            .full(song_full),
                            .din(song_din),
                            .wr_en(song_wr_en),
                            .empty(song_empty),
                            .dout(song_dout),
                            .rd_en(rd_en),
                            .valid(song_valid),
                            .data_count(song_data_count));

comparison score_mod (.clk(clk),
                      .enable(enable),
                      .start(valid),
                      .sung_freq_in(song_dout), //15 bits in Hz
                      .ref_freq_in(ref_dout),
                      .rd_en(rd_en),
                      .score(score),
                      .score_ready(score_ready));

fifo_generator_0 ref_fifo  (.clk(clk),
                            .srst(rst),
                            .full(ref_full),
                            .din(ref_din),
                            .wr_en(ref_wr_en),
                            .empty(ref_empty),
                            .dout(ref_dout),
                            .rd_en(rd_en),
                            .valid(ref_valid),
                            .data_count(ref_data_count));

tally score_av (.clk(clk),
                .reset(rst),
                .score_ready(score_ready),
                .score(score),
                .score_avg(score_avg));                   


endmodule
