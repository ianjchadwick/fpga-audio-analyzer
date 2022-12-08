`timescale 1ns / 1ps

//A module to simulate the results of the FFT coming into the FIFOs for the purposes
//of demonstrating the scoring module and the VGA display
module freq_loader(
    input clk,
          rst,
          start,
          
    output reg wr_en = 1'b0,
    output  [14:0] ref_freq,
            [14:0] song_freq);

localparam

IDLE = 3'b000,
LOAD = 3'b001,
FINISH = 3'b111;
    
reg [14:0] ref_frequencies  [5:0];
reg [14:0] song_frequencies [5:0];
reg [ 3:0] counter = 4'd0;
reg [ 2:0] STATE = 3'd0;
reg wr_delay_cntr = 1'b0;


initial begin
                              //avg_score = 0

ref_frequencies[0] = 15'd440; //A4 to A4
song_frequencies[0] = 15'd440; //score = 10
                               //avg_score = 10

ref_frequencies[1] = 15'd440; //A4 to E4
song_frequencies[1] = 15'd329; //score = 0
                             //avg_score = 5

ref_frequencies[2] = 15'd440;//A4 to G4
song_frequencies[2] = 15'd390; //score = 5
                             //avg_score = 5
                             
ref_frequencies[3] = 15'd440;  //A4 to A4
song_frequencies[3] = 15'd448; //score = 10
                               //avg_score = 6

ref_frequencies[4] = 15'd440; //A4 to A4
song_frequencies[4] = 15'd462;//score = 7
                             //avg_score = 6

ref_frequencies[5] = 15'd440; //A4 to A#4
song_frequencies[5] = 15'd466;//score = 7
                             //avg_score = 6

end

assign ref_freq = ref_frequencies[counter];
assign song_freq = song_frequencies[counter];    
    
always@(posedge clk)
begin
    case(STATE)
        IDLE: begin 
                if(start)
                begin
                    STATE <= LOAD;
                    wr_en <= 1'b1;
                end
                else
                    STATE <= IDLE;
              end//IDLE
        
        LOAD: begin
                if (counter >= 4'd5)
                    begin
                        STATE <= IDLE;
                        counter <= 4'd0;
                        wr_en <= 1'b0;
                    end
                else
                    begin
                        STATE <= LOAD;
                        wr_en <= 1'b1;
                        counter <= counter + 1;
                    end
              end
    
    
    
    endcase

end    
    
    
endmodule
