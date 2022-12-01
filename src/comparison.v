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
SCORE   = 3'b010,
FINISH  = 3'b111;


reg [2:0] counter = 3'd0;
reg [2:0] STATE   = 3'd0;

reg [14:0] sung_in_reg = 15'd0,
           ref_in_reg  = 15'd0,
           
           //To hold frequencies for octaves above and below ref_freq in the range of note scale (20Hz to 20kHz)
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
                    ref_in_reg <= ref_freq_in;
                    sung_in_reg <= sung_freq_in;
                    STATE <= OCTAVES;
                end
            else
                STATE <= IDLE;
         end//IDLE
   
   //Find the frequency of the reference note's 'octaves' above and/or below reference frequency in the range [16Hz,10KHz]
   //Unused registers for freq out of range are filled with 0s
   OCTAVES: begin
              STATE <= SCORE;
              //Fill in the frequencies for octacves above
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
                    oct_below7 <= ref_in_reg >> 8;
              else
                    oct_below7 <= 15'd0;

              if (ref_in_reg >= 15'd2_000)
                    oct_below6 <= ref_in_reg >> 7;
              else
                    oct_below6 <= 15'd0;
              
              if (ref_in_reg >= 15'd1_000)
                    oct_below5 <= ref_in_reg >> 6;
              else
                    oct_below5 <= 15'd0;
                    
              if (ref_in_reg >= 15'd500)
                    oct_below4 <= ref_in_reg >> 5;
              else
                    oct_below4 <= 15'd0;
              
              if (ref_in_reg >= 15'd250)
                    oct_below3 <= ref_in_reg >> 4;
              else
                    oct_below3 <= 15'd0;
              
              if (ref_in_reg >= 15'd125)
                    oct_below2 <= ref_in_reg >> 3;
              else
                    oct_below2 <= 15'd0;
              
              if (ref_in_reg >= 15'd62)
                    oct_below1 <= ref_in_reg >> 2;
              else
                    oct_below1 <= 15'd0;
             
             if (ref_in_reg >= 15'd32)
                    oct_below0 <= ref_in_reg >> 1;
              else
                    oct_below0 <= 15'd0;
            end//OCTAVES
     
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
