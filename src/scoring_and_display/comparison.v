`timescale 1ns / 1ps

module comparison(
input clk,
      enable, 
      start,               //Signal that the next frequency is ready
input [14:0] sung_freq_in, //15 bits in Hz
             ref_freq_in,
output reg rd_en = 1'b0,
output reg score_ready = 1'b0,             
output reg [3:0] score = 4'd0);

localparam

//STATES
IDLE    = 3'b000,
OCTAVES = 3'b001,
CENTER  = 3'b010,
SCORE   = 3'b011,
FINISH  = 3'b111;


reg [2:0] counter = 3'd0;
reg [2:0] STATE   = 3'd0;
reg [3:0] ref_oct = 4'd0;

reg [14:0] octave [8:0];

reg [14:0] sung_in_reg = 15'd0,
           ref_in_reg  = 15'd0,
           
           //To hold frequencies for octaves above and below ref_freq in the range of note scale (16Hz,8KHz)
           oct_above0  = 15'd0,
           oct_above1  = 15'd0,
           oct_above2  = 15'd0,
           oct_above3  = 15'd0,
           oct_above4  = 15'd0,
           oct_above5  = 15'd0,
           oct_above6  = 15'd0,
           oct_above7  = 15'd0,
           oct_above8  = 15'd0,

           oct_below0  = 15'd0,
           oct_below1  = 15'd0,
           oct_below2  = 15'd0,
           oct_below3  = 15'd0,
           oct_below4  = 15'd0,
           oct_below5  = 15'd0,
           oct_below6  = 15'd0,
           oct_below7  = 15'd0,
           oct_below8  = 15'd0;

always@(posedge clk)begin
if(enable) begin
case(STATE)

   IDLE: begin
           //Reset registers
           ref_oct     <= 4'd0;
           score_ready <= 1'b0;
           oct_above0  <= 15'd0;
           oct_above1  <= 15'd0;
           oct_above2  <= 15'd0;
           oct_above3  <= 15'd0;
           oct_above4  <= 15'd0;
           oct_above5  <= 15'd0;
           oct_above6  <= 15'd0;
           oct_above7  <= 15'd0;
           oct_above8  <= 15'd0;
    
           oct_below0  <= 15'd0;
           oct_below1  <= 15'd0;
           oct_below2  <= 15'd0;
           oct_below3  <= 15'd0;
           oct_below4  <= 15'd0;
           oct_below5  <= 15'd0;
           oct_below6  <= 15'd0;
           oct_below7  <= 15'd0;
           oct_below8  <= 15'd0;
            if(start)
                begin
                    ref_in_reg <= ref_freq_in;   //get note to compare against
                    sung_in_reg <= sung_freq_in; //get note that was sung\
                    rd_en <= 1'b1;
                    STATE <= OCTAVES;
                end
            else
                STATE <= IDLE;
         end//IDLE
   
   //Find the frequency of the reference note's 'octaves' above and/or below reference frequency in the range [16Hz,8KHz]
   //Unused registers for freq out of range are filled with 0s
   OCTAVES: begin
              
              STATE <= CENTER;
              rd_en <= 1'b0;
              
              //Figure out what octave reference note is in
              if(ref_in_reg > 15'd4_000)
                ref_oct <= 4'd8;
              else if ((ref_in_reg <= 15'd4_000) &&  (ref_in_reg > 15'd2_000))
                ref_oct <= 4'd7;
              else if ((ref_in_reg <= 15'd2_000) &&  (ref_in_reg > 15'd1_000))
                ref_oct <= 4'd6;
              else if ((ref_in_reg <= 15'd1_000) &&  (ref_in_reg > 15'd500))
                ref_oct <= 4'd5;
              else if ((ref_in_reg <= 15'd500) &&  (ref_in_reg > 15'd250))
                ref_oct <= 4'd4;
              else if ((ref_in_reg <= 15'd250) &&  (ref_in_reg > 15'd125))
                ref_oct <= 4'd3;  
              else if ((ref_in_reg <= 15'd125) &&  (ref_in_reg > 15'd62))
                ref_oct <= 4'd2;
              else if ((ref_in_reg <= 15'd62) &&  (ref_in_reg > 15'd31))
                ref_oct <= 4'd1;
              else
                ref_oct <= 4'd0;
                        
              //Fill in the frequencies for all the octacves above
              if(ref_in_reg < 15'd4_000)
                    oct_above0 <= ref_in_reg << 1;
               else
                    oct_above0 <= 15'd0;
              
              if(ref_in_reg <= 15'd2_000)
                    oct_above1 <= ref_in_reg << 2;
               else
                    oct_above1 <= 15'd0;
                
              if(ref_in_reg <= 15'd1_000)
                    oct_above2 <= ref_in_reg << 3;
               else
                    oct_above2 <= 15'd0;
              
              if(ref_in_reg <= 15'd500)
                    oct_above3 <= ref_in_reg << 4;
               else
                    oct_above3 <= 15'd0;
                
              if(ref_in_reg <= 15'd250)
                    oct_above4 <= ref_in_reg << 5;
               else
                    oct_above4 <= 15'd0;
               
               if(ref_in_reg <= 15'd125)
                    oct_above5 <= ref_in_reg << 6;
               else
                    oct_above5 <= 15'd0;
               
               if(ref_in_reg <= 15'd62)
                    oct_above6 <= ref_in_reg << 7;
               else
                    oct_above6 <= 15'd0;
               
               if(ref_in_reg <= 15'd32)
                    oct_above7 <= ref_in_reg << 8;
               else
                    oct_above7 <= 15'd0;
                    
           
              //Fill in frequencies for octaves below
              if (ref_in_reg >= 15'd4_000)
                    begin
                    oct_below7 <= ref_in_reg >> 8;
                    end
              else
                    oct_below7 <= 15'd0;

              if (ref_in_reg >= 15'd2_000)
                    begin
                    oct_below6 <= ref_in_reg >> 7;
                    end
              else
                    oct_below6 <= 15'd0;
              
              if (ref_in_reg >= 15'd1_000)
                    begin
                    oct_below5 <= ref_in_reg >> 6;
                    end
              else
                    oct_below5 <= 15'd0;
                    
              if (ref_in_reg >= 15'd500)
                    begin
                    oct_below4 <= ref_in_reg >> 5;
                    end
              else
                    oct_below4 <= 15'd0;
              
              if (ref_in_reg >= 15'd250)
                    begin
                    oct_below3 <= ref_in_reg >> 4;
                    end
              else
                    oct_below3 <= 15'd0;
              
              if (ref_in_reg >= 15'd125)
                    begin
                    oct_below2 <= ref_in_reg >> 3;
                    end
              else
                    oct_below2 <= 15'd0;
              
              if (ref_in_reg >= 15'd62)
                    begin
                    oct_below1 <= ref_in_reg >> 2;
                    end
              else
                    oct_below1 <= 15'd0;
             
             if (ref_in_reg >= 15'd32)
                    begin
                    oct_below0 <= ref_in_reg >> 1;
                    end
              else
                    oct_below0 <= 15'd0;
            end//OCTAVES
     
     //Center octave frequencies found in previous step into the correct bin for scoring purposes
     CENTER: begin
                STATE <= SCORE;
                case(ref_oct)
                4'd0: begin
                      octave[0] <= ref_in_reg;
                      octave[1] <= oct_above0;
                      octave[2] <= oct_above1;
                      octave[3] <= oct_above2;
                      octave[4] <= oct_above3;
                      octave[5] <= oct_above4;
                      octave[6] <= oct_above5;
                      octave[7] <= oct_above6;
                      octave[8] <= oct_above7;
                      end
                4'd1: begin
                      octave[0] <= oct_below0;
                      octave[1] <= ref_in_reg;
                      octave[2] <= oct_above0;
                      octave[3] <= oct_above1;
                      octave[4] <= oct_above2;
                      octave[5] <= oct_above3;
                      octave[6] <= oct_above4;
                      octave[7] <= oct_above5;
                      octave[8] <= oct_above6;
                      end
                4'd2: begin
                      octave[0] <= oct_below1;
                      octave[1] <= oct_below0;
                      octave[2] <= ref_in_reg;
                      octave[3] <= oct_above0;
                      octave[4] <= oct_above1;
                      octave[5] <= oct_above2;
                      octave[6] <= oct_above3;
                      octave[7] <= oct_above4;
                      octave[8] <= oct_above5;
                      end
                4'd3: begin
                      octave[0] <= oct_below2;
                      octave[1] <= oct_below1;
                      octave[2] <= oct_below0;
                      octave[3] <= ref_in_reg;
                      octave[4] <= oct_above0;
                      octave[5] <= oct_above1;
                      octave[6] <= oct_above2;
                      octave[7] <= oct_above3;
                      octave[8] <= oct_above4;
                      end
                4'd4: begin
                      octave[0] <= oct_below3;
                      octave[1] <= oct_below2;
                      octave[2] <= oct_below1;
                      octave[3] <= oct_below0;
                      octave[4] <= ref_in_reg;
                      octave[5] <= oct_above0;
                      octave[6] <= oct_above1;
                      octave[7] <= oct_above2;
                      octave[8] <= oct_above3;
                      end
                4'd5: begin
                      octave[0] <= oct_below4;
                      octave[1] <= oct_below3;
                      octave[2] <= oct_below2;
                      octave[3] <= oct_below1;
                      octave[4] <= oct_below0;
                      octave[5] <= ref_in_reg;
                      octave[6] <= oct_above0;
                      octave[7] <= oct_above1;
                      octave[8] <= oct_above2;
                      end
                4'd6: begin
                      octave[0] <= oct_below6;
                      octave[1] <= oct_below5;
                      octave[2] <= oct_below4;
                      octave[3] <= oct_below3;
                      octave[4] <= oct_below2;
                      octave[5] <= oct_below1;
                      octave[6] <= oct_below0;
                      octave[7] <= ref_in_reg;
                      octave[8] <= oct_above0;
                      end
                4'd7: begin
                      octave[0] <= oct_below7;
                      octave[1] <= oct_below6;
                      octave[2] <= oct_below5;
                      octave[3] <= oct_below4;
                      octave[4] <= oct_below3;
                      octave[5] <= oct_below2;
                      octave[6] <= oct_below1;
                      octave[7] <= oct_below0;
                      octave[8] <= ref_in_reg;
                      end   
                endcase
             end
     
     SCORE: begin
            STATE <= IDLE;
            //Full points if it equals the ref frequency or any of the same notes in different octaves +/- acceptable band for the note
            if ((sung_in_reg == octave[0]) ||
                ((sung_in_reg >= octave[1]-15'd1) && (sung_in_reg <= octave[1]+15'd1)) ||
                ((sung_in_reg >= octave[2]-15'd2) && (sung_in_reg <= octave[2]+15'd2)) ||
                ((sung_in_reg >= octave[3]-15'd4) && (sung_in_reg <= octave[3]+15'd4)) ||
                ((sung_in_reg >= octave[4]-15'd8) && (sung_in_reg <= octave[4]+15'd8)) ||
                ((sung_in_reg >= octave[5]-15'd16) && (sung_in_reg <= octave[5]+15'd16)) ||
                ((sung_in_reg >= octave[6]-15'd32) && (sung_in_reg <= octave[6]+15'd32)) ||
                ((sung_in_reg >= octave[7]-15'd64) && (sung_in_reg <= octave[7]+15'd64)) ||
                ((sung_in_reg >= octave[8]-15'd128) && (sung_in_reg <= octave[8]+15'd128)))
                begin
                    score <= 4'd10;
                end//Full Points
            
            //Partial points teir 1
            else if(((sung_in_reg >= octave[1]-15'd2) && (sung_in_reg <= octave[1]+15'd2)) ||
                    ((sung_in_reg >= octave[2]-15'd5) && (sung_in_reg <= octave[2]+15'd5)) ||
                    ((sung_in_reg >= octave[3]-15'd10) && (sung_in_reg <= octave[3]+15'd10)) ||
                    ((sung_in_reg >= octave[4]-15'd26) && (sung_in_reg <= octave[4]+15'd26)) ||
                    ((sung_in_reg >= octave[5]-15'd43) && (sung_in_reg <= octave[5]+15'd43)) ||
                    ((sung_in_reg >= octave[6]-15'd86) && (sung_in_reg <= octave[6]+15'd86)) ||
                    ((sung_in_reg >= octave[7]-15'd173) && (sung_in_reg <= octave[7]+15'd173)) ||
                    ((sung_in_reg >= octave[8]-15'd346) && (sung_in_reg <= octave[8]+15'd346)))
                begin
                    score <= 4'd7;
                end//Teir 1
             
            //Partial points teir 2
            else if(((sung_in_reg >= octave[3]-15'd12) && (sung_in_reg <= octave[3]+15'd12)) ||
                    ((sung_in_reg >= octave[4]-15'd55) && (sung_in_reg <= octave[4]+15'd55)) ||
                    ((sung_in_reg >= octave[5]-15'd86) && (sung_in_reg <= octave[5]+15'd86)) ||
                    ((sung_in_reg >= octave[6]-15'd128) && (sung_in_reg <= octave[6]+15'd128)) ||
                    ((sung_in_reg >= octave[7]-15'd215) && (sung_in_reg <= octave[7]+15'd215)) ||
                    ((sung_in_reg >= octave[8]-15'd650) && (sung_in_reg <= octave[8]+15'd650)))
                begin
                    score <= 4'd5;
                end//Teir 2
            else
                score <= 4'd0;
            score_ready <= 1'b1;                                
            end//SCORE
            
     FINISH: begin
                STATE <=IDLE;
             end

endcase


end//if enable
end    
endmodule
