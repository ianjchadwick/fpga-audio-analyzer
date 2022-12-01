`timescale 1ns / 1ps

module comparison(
input clk,
      enable, 
      start,               //Signal that the next frequency is ready
input [14:0] sung_freq_in, //15 bits in Hz
             ref_freq_in,
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

reg [14:0] octaves [8:0];

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
                    sung_in_reg <= sung_freq_in; //get note that was sung
                    STATE <= OCTAVES;
                end
            else
                STATE <= IDLE;
         end//IDLE
   
   //Find the frequency of the reference note's 'octaves' above and/or below reference frequency in the range [16Hz,8KHz]
   //Unused registers for freq out of range are filled with 0s
   OCTAVES: begin
              
              STATE <= CENTER;
              
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
     
     CENTER: begin
                STATE <= SCORE;
                case(ref_oct)
                4'd0: begin
                      octaves[0] <= ref_in_reg;
                      octaves[1] <= oct_above0;
                      octaves[2] <= oct_above1;
                      octaves[3] <= oct_above2;
                      octaves[4] <= oct_above3;
                      octaves[5] <= oct_above4;
                      octaves[6] <= oct_above5;
                      octaves[7] <= oct_above6;
                      octaves[8] <= oct_above7;
                      end
                4'd1: begin
                      octaves[0] <= oct_below0;
                      octaves[1] <= ref_in_reg;
                      octaves[2] <= oct_above0;
                      octaves[3] <= oct_above1;
                      octaves[4] <= oct_above2;
                      octaves[5] <= oct_above3;
                      octaves[6] <= oct_above4;
                      octaves[7] <= oct_above5;
                      octaves[8] <= oct_above6;
                      end
                4'd2: begin
                      octaves[0] <= oct_below1;
                      octaves[1] <= oct_below0;
                      octaves[2] <= ref_in_reg;
                      octaves[3] <= oct_above0;
                      octaves[4] <= oct_above1;
                      octaves[5] <= oct_above2;
                      octaves[6] <= oct_above3;
                      octaves[7] <= oct_above4;
                      octaves[8] <= oct_above5;
                      end
                4'd3: begin
                      octaves[0] <= oct_below2;
                      octaves[1] <= oct_below1;
                      octaves[2] <= oct_below0;
                      octaves[3] <= ref_in_reg;
                      octaves[4] <= oct_above0;
                      octaves[5] <= oct_above1;
                      octaves[6] <= oct_above2;
                      octaves[7] <= oct_above3;
                      octaves[8] <= oct_above4;
                      end
                4'd4: begin
                      octaves[0] <= oct_below3;
                      octaves[1] <= oct_below2;
                      octaves[2] <= oct_below1;
                      octaves[3] <= oct_below0;
                      octaves[4] <= ref_in_reg;
                      octaves[5] <= oct_above0;
                      octaves[6] <= oct_above1;
                      octaves[7] <= oct_above2;
                      octaves[8] <= oct_above3;
                      end
                4'd5: begin
                      octaves[0] <= oct_below4;
                      octaves[1] <= oct_below3;
                      octaves[2] <= oct_below2;
                      octaves[3] <= oct_below1;
                      octaves[4] <= oct_below0;
                      octaves[5] <= ref_in_reg;
                      octaves[6] <= oct_above0;
                      octaves[7] <= oct_above1;
                      octaves[8] <= oct_above2;
                      end
                4'd6: begin
                      octaves[0] <= oct_below5;
                      octaves[1] <= oct_below4;
                      octaves[2] <= oct_below3;
                      octaves[3] <= oct_below2;
                      octaves[4] <= oct_below1;
                      octaves[5] <= oct_below0;
                      octaves[6] <= ref_in_reg;
                      octaves[7] <= oct_above0;
                      octaves[8] <= oct_above1;
                      end
                4'd6: begin
                      octaves[0] <= oct_below6;
                      octaves[1] <= oct_below5;
                      octaves[2] <= oct_below4;
                      octaves[3] <= oct_below3;
                      octaves[4] <= oct_below2;
                      octaves[5] <= oct_below1;
                      octaves[6] <= oct_below0;
                      octaves[7] <= ref_in_reg;
                      octaves[8] <= oct_above0;
                      end
                4'd7: begin
                      octaves[0] <= oct_below7;
                      octaves[1] <= oct_below6;
                      octaves[2] <= oct_below5;
                      octaves[3] <= oct_below4;
                      octaves[4] <= oct_below3;
                      octaves[5] <= oct_below2;
                      octaves[6] <= oct_below1;
                      octaves[7] <= oct_below0;
                      octaves[8] <= ref_in_reg;
                      end   
                endcase
             end
     
     SCORE: begin
            
            //Full points if it equals the ref frequency or any of the same notes in different octaves
            if ((sung_in_reg == ref_in_reg) ||
                ((oct_above0 != 15'd0) && (sung_in_reg == oct_above0)) ||
                ((oct_above1 != 15'd0) && (sung_in_reg == oct_above1)) ||
                ((oct_above2 != 15'd0) && (sung_in_reg == oct_above2)) ||
                ((oct_above3 != 15'd0) && (sung_in_reg == oct_above3)) ||
                ((oct_above4 != 15'd0) && (sung_in_reg == oct_above4)) ||
                ((oct_above5 != 15'd0) && (sung_in_reg == oct_above5)) ||
                ((oct_above6 != 15'd0) && (sung_in_reg == oct_above6)) ||
                ((oct_above7 != 15'd0) && (sung_in_reg == oct_above7)) ||
                ((oct_above8 != 15'd0) && (sung_in_reg == oct_above8)) ||
                ((oct_below0 != 15'd0) && (sung_in_reg == oct_below0)) ||
                ((oct_below1 != 15'd0) && (sung_in_reg == oct_below1)) ||
                ((oct_below2 != 15'd0) && (sung_in_reg == oct_below2)) ||
                ((oct_below3 != 15'd0) && (sung_in_reg == oct_below3)) ||
                ((oct_below4 != 15'd0) && (sung_in_reg == oct_below4)) ||
                ((oct_below5 != 15'd0) && (sung_in_reg == oct_below5)) ||
                ((oct_below6 != 15'd0) && (sung_in_reg == oct_below6)) ||
                ((oct_below7 != 15'd0) && (sung_in_reg == oct_below7)) ||
                ((oct_below8 != 15'd0) && (sung_in_reg == oct_below8))
                )
                begin
                    score <= 4'd10;
                    //STATE <= IDLE;
                end//Full Points if 
     
            end//SCORE
            
     FINISH: begin
           
           STATE <=IDLE;
             end

endcase


end//if enable
end    
endmodule
