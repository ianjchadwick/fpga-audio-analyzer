import string


if __name__ == "__main__":
    
    vga_hcnt = "vga_hcnt"
    h_start = 0
    v_start = 400
    h_step_size = 5
    vga_vcnt = "vga_vcnt"
    reg_name = "bot_"
    
    column_num = 127
    row_num = 15

    v_step_size = 5



    r_on_color = "BOT_R_ON"
    g_on_color = "BOT_G_ON"
    b_on_color = "BOT_B_ON"

    r_off_color = "BOT_R_OFF"
    g_off_color = "BOT_G_OFF"
    b_off_color = "BOT_B_OFF"

    newline = "\n"

    text_file = open('verilog.txt', 'x')

    for row in range(0,row_num+1):
        for column in range(0,column_num+1):
            verilog_code = f"\
            if ( ( ({vga_hcnt} >= {h_start + 1 + column*h_step_size}) && ({vga_hcnt} <= {h_start + (column+1)*h_step_size})) &&{newline}\
                ( ({vga_vcnt} >= {v_start + 1 + (row*v_step_size)}) && ({vga_vcnt} <= {v_start + (row+1)*v_step_size}) ) ) begin{newline}\
            if({reg_name}row{row}[{column_num - column}] == 1'b1){newline}\
                begin{newline}\
                    VGA_R = {r_on_color};{newline}\
                    VGA_G = {g_on_color};{newline}\
                    VGA_B = {b_on_color};{newline}\
                end{newline}\
            else{newline}\
                begin{newline}\
                    VGA_R = {r_off_color};{newline}\
                    VGA_G = {g_off_color};{newline}\
                    VGA_B = {b_off_color};{newline}\
                end{newline}\
            {newline}\
            end{newline}\
            {newline}"
            text_file.write(verilog_code)
    text_file.close()
