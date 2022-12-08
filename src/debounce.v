`timescale 1ns / 1ps
 
   module debounce(button, clk, button_out);
    input button, clk;
    output reg button_out;
    
    reg [26:0] counter = 27'd0;
    
    always@(posedge clk)
    begin
        if(button == 1'b1)
            begin
                if(counter == 27'd99_999_999)
                    begin
                        button_out <= 1'b1;
                        counter <= 27'd0;
                    end
                else
                    begin
                        button_out <= 1'b0;
                        counter <= counter+1'b1;
                    end
            end
        else
            begin
                counter <= 27'd0;
            end
    end
    
 endmodule
