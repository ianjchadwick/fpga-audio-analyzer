`timescale 1ns / 1ps

module test_top(
input clk, 
      BTNC, /*for start*/ 
      BTNU, /*for rst*/
output [3:0] VGA_R,
output [3:0] VGA_G,
output [3:0] VGA_B,
output VGA_HS,
output VGA_VS
//output [ 3:0] score_avg //for testbench
);

wire rst, start;

//assign start = BTNC; //for testbench

debounce db_rst (.clk(clk), .button(BTNU), .button_out(rst));
debounce db_start (.clk(clk), .button(BTNC), .button_out(start));

reg enable = 1'b1;

wire rd_en, wr_en, valid, song_valid, ref_valid;

wire [14:0] song_dout,
            ref_dout,
            song_freq,
            ref_freq;

wire [3:0] score,
           score_avg;
           
freq_loader for_demo (.clk(clk),
                      .rst(rst),
                      .start(start),
                      .wr_en(wr_en),
                      .ref_freq(ref_freq),
                      .song_freq(song_freq));
                      

assign valid = song_valid & ref_valid;

fifo_generator_0 song_fifo (.clk(clk),
                            .srst(rst),
                            .full(song_full),
                            .din(song_freq),
                            .wr_en(wr_en),
                            .empty(song_empty),
                            .dout(song_dout),
                            .rd_en(rd_en),
                            .valid(song_valid),
                            .data_count());

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
                            .din(ref_freq),
                            .wr_en(wr_en),
                            .empty(ref_empty),
                            .dout(ref_dout),
                            .rd_en(rd_en),
                            .valid(ref_valid),
                            .data_count());

tally score_av (.clk(clk),
                .reset(rst),
                .score_ready(score_ready),
                .score(score),
                .score_avg(score_avg));

vga_top vga_mod (.clk(clk),
                 .score(score_avg),
                 .VGA_R(VGA_R),
                 .VGA_G(VGA_G),
                 .VGA_B(VGA_B),
                 .VGA_HS(VGA_HS),
                 .VGA_VS(VGA_VS));                              


endmodule
