`timescale 1ns / 1ps

// Generate HS, VS signals from pixel clock.
// hcounter & vcounter are the index of the current pixel 
// origin (0, 0) at top-left corner of the screen
// valid display range for hcounter: [0, 640)
// valid display range for vcounter: [0, 480)
module vga_controller_640_60 (pixel_clk,HS,VS,hcounter,vcounter,blank);

	input pixel_clk;
	output HS, VS, blank;
	output [10:0] hcounter, vcounter;

	parameter HMAX = 800; // maximum value for the horizontal pixel counter
	parameter VMAX = 525; // maximum value for the vertical pixel counter
	parameter HLINES = 640; // total number of visible columns
	parameter HFP = 648; // value for the horizontal counter where front porch ends
	parameter HSP = 744; // value for the horizontal counter where the synch pulse ends
	parameter VLINES = 480; // total number of visible lines
	parameter VFP = 482; // value for the vertical counter where the front porch ends
	parameter VSP = 484; // value for the vertical counter where the synch pulse ends
	parameter SPP = 0;


	wire video_enable;
	reg HS,VS,blank;
	reg [10:0] hcounter,vcounter;

	always@(posedge pixel_clk)begin
		blank <= ~video_enable; 
	end

	always@(posedge pixel_clk)begin
		if (hcounter == HMAX) hcounter <= 0;
		else hcounter <= hcounter + 1;
	end

	always@(posedge pixel_clk)begin
		if(hcounter == HMAX) begin
			if(vcounter == VMAX) vcounter <= 0;
			else vcounter <= vcounter + 1; 
		end
	end

	always@(posedge pixel_clk)begin
		if(hcounter >= HFP && hcounter < HSP) HS <= SPP;
		else HS <= ~SPP; 
	end

	always@(posedge pixel_clk)begin
		if(vcounter >= VFP && vcounter < VSP) VS <= SPP;
		else VS <= ~SPP; 
	end

	assign video_enable = (hcounter < HLINES && vcounter < VLINES) ? 1'b1 : 1'b0;

endmodule


// top module that instantiate the VGA controller and generate images
module top(
    input clk,
    input [3:0] score,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS
    );


reg pclk_div_cnt;
reg pixel_clk;
reg [3:0] row_counter = 4'd0;
wire [10:0] vga_hcnt, vga_vcnt;
wire vga_blank;

reg       [15:0] row0 = 16'd0,
                 row1 = 16'd0,
                 row2 = 16'd0,
                 row3 = 16'd0,
                 row4 = 16'd0,
                 row5 = 16'd0,
                 row6 = 16'd0,
                 row7 = 16'd0,
                 row8 = 16'd0,
                 row9 = 16'd0,
                 row10 = 16'd0,
                 row11 = 16'd0,
                 row12 = 16'd0,
                 row13 = 16'd0,
                 row14 = 16'd0,
                 row15 = 16'd0;

//Bits with a 1 are black 0 are white in the 320x320 grid in the center
//each case corresponds to displaying that digit
always@(score)begin
    case(score)
    4'd10:  begin
                 row0  = 16'b0000000000000000;
                 row1  = 16'b0000000000000000;
                 row2  = 16'b0001100001111100;
                 row3  = 16'b0011100011000110;
                 row4  = 16'b0111100011000110;
                 row5  = 16'b0001100011001110;
                 row6  = 16'b0001100011011110;
                 row7  = 16'b0001100011110110;
                 row8  = 16'b0001100011100110;
                 row9  = 16'b0001100011000110;
                 row10 = 16'b0001100011000110;
                 row11 = 16'b0111111001111100;
                 row12 = 16'b0000000000000000;
                 row13 = 16'b0000000000000000;
                 row14 = 16'b0000000000000000;
                 row15 = 16'b0000000000000000;
            end
    
    4'd9:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_01111100_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_11000110_0000;
                 row5  = 16'b0000_11000110_0000;
                 row6  = 16'b0000_01111110_0000;
                 row7  = 16'b0000_00000110_0000;
                 row8  = 16'b0000_00000110_0000;
                 row9  = 16'b0000_00000110_0000;
                 row10 = 16'b0000_00001100_0000;
                 row11 = 16'b0000_01111000_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    4'd8:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_01111100_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_11000110_0000;
                 row5  = 16'b0000_11000110_0000;
                 row6  = 16'b0000_01111100_0000;
                 row7  = 16'b0000_11000110_0000;
                 row8  = 16'b0000_11000110_0000;
                 row9  = 16'b0000_11000110_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_01111100_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    
    4'd7:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_11111110_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_00000110_0000;
                 row5  = 16'b0000_00000110_0000;
                 row6  = 16'b0000_00001100_0000;
                 row7  = 16'b0000_00011000_0000;
                 row8  = 16'b0000_00110000_0000;
                 row9  = 16'b0000_00110000_0000;
                 row10 = 16'b0000_00110000_0000;
                 row11 = 16'b0000_00110000_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
            
    4'd6:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_00111000_0000;
                 row3  = 16'b0000_01100000_0000;
                 row4  = 16'b0000_11000000_0000;
                 row5  = 16'b0000_11000000_0000;
                 row6  = 16'b0000_11111100_0000;
                 row7  = 16'b0000_11000110_0000;
                 row8  = 16'b0000_11000110_0000;
                 row9  = 16'b0000_11000110_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_01111100_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
            
    4'd5:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_11111110_0000;
                 row3  = 16'b0000_11000000_0000;
                 row4  = 16'b0000_11000000_0000;
                 row5  = 16'b0000_11000000_0000;
                 row6  = 16'b0000_11111100_0000;
                 row7  = 16'b0000_00000110_0000;
                 row8  = 16'b0000_00000110_0000;
                 row9  = 16'b0000_00000110_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_01111100_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
            
    4'd4:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_00001100_0000;
                 row3  = 16'b0000_00011100_0000;
                 row4  = 16'b0000_00111100_0000;
                 row5  = 16'b0000_01101100_0000;
                 row6  = 16'b0000_11001100_0000;
                 row7  = 16'b0000_11111110_0000;
                 row8  = 16'b0000_00001100_0000;
                 row9  = 16'b0000_00001100_0000;
                 row10 = 16'b0000_00001100_0000;
                 row11 = 16'b0000_00011110_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    
    4'd3:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_01111100_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_00000110_0000;
                 row5  = 16'b0000_00000110_0000;
                 row6  = 16'b0000_00111100_0000;
                 row7  = 16'b0000_00000110_0000;
                 row8  = 16'b0000_00000110_0000;
                 row9  = 16'b0000_00000110_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_01111100_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    
    4'd2:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_01111100_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_00000110_0000;
                 row5  = 16'b0000_00001100_0000;
                 row6  = 16'b0000_00011000_0000;
                 row7  = 16'b0000_00110000_0000;
                 row8  = 16'b0000_01100000_0000;
                 row9  = 16'b0000_11000000_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_11111110_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    
    4'd1:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_00011000_0000;
                 row3  = 16'b0000_00111000_0000;
                 row4  = 16'b0000_01111000_0000;
                 row5  = 16'b0000_00011000_0000;
                 row6  = 16'b0000_00011000_0000;
                 row7  = 16'b0000_00011000_0000;
                 row8  = 16'b0000_00011000_0000;
                 row9  = 16'b0000_00011000_0000;
                 row10 = 16'b0000_00011000_0000;
                 row11 = 16'b0000_01111110_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
            
    4'd0:   begin
                 row0  = 16'b0000_00000000_0000;
                 row1  = 16'b0000_00000000_0000;
                 row2  = 16'b0000_01111100_0000;
                 row3  = 16'b0000_11000110_0000;
                 row4  = 16'b0000_11000110_0000;
                 row5  = 16'b0000_11001110_0000;
                 row6  = 16'b0000_11011110_0000;
                 row7  = 16'b0000_11110110_0000;
                 row8  = 16'b0000_11100110_0000;
                 row9  = 16'b0000_11000110_0000;
                 row10 = 16'b0000_11000110_0000;
                 row11 = 16'b0000_01111100_0000;
                 row12 = 16'b0000_00000000_0000;
                 row13 = 16'b0000_00000000_0000;
                 row14 = 16'b0000_00000000_0000;
                 row15 = 16'b0000_00000000_0000;
            end
    
    default begin
                 row0 = 16'd0;
                 row1 = 16'd0;
                 row2 = 16'd0;
                 row3 = 16'd0;
                 row4 = 16'd0;
                 row5 = 16'd0;
                 row6 = 16'd0;
                 row7 = 16'd0;
                 row8 = 16'd0;
                 row9 = 16'd0;
                 row10 = 16'd0;
                 row11 = 16'd0;
                 row12 = 16'd0;
                 row13 = 16'd0;
                 row14 = 16'd0;
                 row15 = 16'd0;
            end
    
    endcase

end









// Clock divider. Generate 25MHz pixel_clk from 100MHz clock.
always @(posedge clk) begin
    pclk_div_cnt <= !pclk_div_cnt;
    if (pclk_div_cnt == 1'b1) pixel_clk <= !pixel_clk;
end



// Instantiate VGA controller
vga_controller_640_60 vga_controller(
    .pixel_clk(pixel_clk),
    .HS(VGA_HS),
    .VS(VGA_VS),
    .hcounter(vga_hcnt),
    .vcounter(vga_vcnt),
    .blank(vga_blank)
);

// Generate figure to be displayed
// Decide the color for the current pixel at index (hcnt, vcnt).
// This example displays an white square at the center of the screen with a colored checkerboard background.
always @(*) begin
    // Set pixels to black during Sync. Failure to do so will result in dimmed colors or black screens.
    if (vga_blank) begin 
        VGA_R = 0;
        VGA_G = 0;
        VGA_B = 0;
    end
    else begin  // Image to be displayed
        VGA_R = 4'h2;
        VGA_G = 4'h2;
        VGA_B = 4'h2;
        
        

        /*************************SCORE SECTION******************************/
        
        //Centered 320x320 square matrix in 20x20 blocks [Row, Col]
        //Row0
        //[0,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
            if(row0[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[0,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 81 && vga_vcnt <= 100)) begin
			if(row0[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW1
        //[1,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[1,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 101 && vga_vcnt <= 120)) begin
			if(row1[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW2
        //[2,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[2,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 121 && vga_vcnt <= 140)) begin
			if(row2[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW3
        //[3,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[3,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 141 && vga_vcnt <= 160)) begin
			if(row3[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW4
        //[4,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[4,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 161 && vga_vcnt <= 180)) begin
			if(row4[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW5
        //[5,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[5,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 181 && vga_vcnt <= 200)) begin
			if(row5[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW6
        //[6,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[6,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 201 && vga_vcnt <= 220)) begin
			if(row6[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW7
        //[7,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[7,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 221 && vga_vcnt <= 240)) begin
			if(row7[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW8
        //[8,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[8,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 241 && vga_vcnt <= 260)) begin
			if(row8[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW9
        //[9,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[9,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 261 && vga_vcnt <= 280)) begin
			if(row9[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW10
        //[10,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[10,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 281 && vga_vcnt <= 300)) begin
			if(row10[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW11
        //[11,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[11,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 301 && vga_vcnt <= 320)) begin
			if(row11[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW12
        //[12,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[12,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 321 && vga_vcnt <= 340)) begin
			if(row12[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW13
        //[13,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[13,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 341 && vga_vcnt <= 360)) begin
			if(row13[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW14
        //[14,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[14,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 361 && vga_vcnt <= 380)) begin
			if(row14[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //ROW15
        //[15,0]
        if ((vga_hcnt >= 161 && vga_hcnt <= 180) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[15] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,1]
        if ((vga_hcnt >= 181 && vga_hcnt <= 200) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[14] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,2]
        if ((vga_hcnt >= 201 && vga_hcnt <= 220) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[13] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,3]
        if ((vga_hcnt >= 221 && vga_hcnt <= 240) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[12] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,4]
        if ((vga_hcnt >= 241 && vga_hcnt <= 260) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[11] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,5]
        if ((vga_hcnt >= 261 && vga_hcnt <= 280) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[10] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,6]
        if ((vga_hcnt >= 281 && vga_hcnt <= 300) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[9] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,7]
        if ((vga_hcnt >= 301 && vga_hcnt <= 320) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[8] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,8]
        if ((vga_hcnt >= 321 && vga_hcnt <= 340) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[7] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,9]
        if ((vga_hcnt >= 341 && vga_hcnt <= 360) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[6] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,10]
        if ((vga_hcnt >= 361 && vga_hcnt <= 380) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[5] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,11]
        if ((vga_hcnt >= 381 && vga_hcnt <= 400) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[4] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,12]
        if ((vga_hcnt >= 401 && vga_hcnt <= 420) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[3] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,13]
        if ((vga_hcnt >= 421 && vga_hcnt <= 440) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[2] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,14]
        if ((vga_hcnt >= 441 && vga_hcnt <= 460) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[1] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        //[15,15]
        if ((vga_hcnt >= 461 && vga_hcnt <= 480) &&
        	(vga_vcnt >= 381 && vga_vcnt <= 400)) begin
			if(row15[0] == 1'b1)
                begin
                    VGA_R = 4'h0;
                    VGA_G = 4'h0;
                    VGA_B = 4'h0;
                end
            else
                begin
                    VGA_R = 4'h8;
                    VGA_G = 4'h8;
                    VGA_B = 4'h8;
                end
        end
        
        
    end//else !blank
end

endmodule
