`timescale 1ns / 1ps

module freq_loader_tb();

reg clk,
    rst,
    start;
          
wire wr_en;
wire [14:0] ref_freq,
            song_freq;
            
reg rd;

wire [14:0] dout;
wire [11:0] data_count;
wire valid, full, empty;            

wire [14:0] dout2;
wire [11:0] data_count2;
wire valid2, full2, empty2;  

freq_loader UUT   (.clk(clk),
                   .rst(rst),
                   .start(start),
                   .wr_en(wr_en),
                   .ref_freq(ref_freq),
                   .song_freq(song_freq));
                   
fifo_generator_0 song_fifo (.clk(clk),
                            .srst(rst),
                            .full(full),
                            .din(song_freq),
                            .wr_en(wr_en),
                            .empty(empty),
                            .dout(dout),
                            .rd_en(rd),
                            .valid(valid),
                            .data_count(data_count));
                            
fifo_generator_0 ref_fifo  (.clk(clk),
                            .srst(rst),
                            .full(full2),
                            .din(ref_freq),
                            .wr_en(wr_en),
                            .empty(empty2),
                            .dout(dout2),
                            .rd_en(rd),
                            .valid(valid2),
                            .data_count(data_count2));                            



always #5 clk = ~clk;
                   
initial begin
clk   = 0;
rst   = 0;
start = 0;
rd = 0;
#5;
start = 1;
#10;
start = 0;
#150;
rd = 1;
#20;
//rd = 0;
//#10;
//start=1;
//#10;
//start =0;
end                                     


endmodule
