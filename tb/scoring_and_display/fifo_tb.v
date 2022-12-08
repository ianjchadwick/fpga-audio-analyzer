`timescale 1ns / 1ps

module fifo_tb();


reg clk, rst, wr, rd;
reg [14:0] in;

wire [14:0] dout;
wire [11:0] data_count;
wire valid, full, empty;

//fifo_mem UUT (.data_out(dout),
//              .fifo_full(full), 
//              .fifo_empty(empty), 
//              .fifo_threshold(), 
//              .fifo_overflow(), 
//              .fifo_underflow(),
//              .clk(clk), 
//              .rst_n(rst), 
//              .wr(wr), 
//              .rd(rd), 
//              .data_in(in));


fifo_generator_0 song_fifo (.clk(clk),
                            .srst(rst),
                            .full(full),
                            .din(in),
                            .wr_en(wr),
                            .empty(empty),
                            .dout(dout),
                            .rd_en(rd),
                            .valid(valid),
                            .data_count(data_count));

always #5 clk = ~clk;

initial begin
clk = 0;
rst = 1;
wr = 0;
rd = 0;
in =0;
#1;
rst = 0;
in = 15'd481;
#4;
wr = 1;
#10;
in = 15'd481;
wr = 0;
rd = 1;


end


endmodule
